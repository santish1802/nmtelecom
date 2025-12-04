<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mi Carrito</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/custom-style.css">
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<%@ include file="/jsp/includes/navbar.jspf" %>
<section class="hero-section">
    <div class="container">
        <div class="hero-content text-center">
            <h1 class="page-title">Mi Carrito</h1>
            <p class="page-subtitle">Revisa tus productos antes de finalizar la compra</p>
        </div>
    </div>
</section>
<div class="container my-5">
    <c:if test="${empty items}">
        <div class="alert alert-info" id="empty-cart-message">Tu carrito está vacío.</div>
    </c:if>

    <c:if test="${not empty items}">
        <div class="table-responsive">
            <table class="table table-hover align-middle" id="cart-table">
                <thead>
                    <tr>
                        <th>Producto</th>
                        <th>Cantidad</th>
                        <th>Precio Unitario</th>
                        <th>Subtotal</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
        <c:set var="total" value="0"/>
        <c:forEach var="item" items="${items}">
            <tr data-id="${item.idItem}">
                <td class="product-name">${item.nombre}</td>

                <td>
                    <div class="input-group input-group-sm" style="max-width: 120px;">
                        <button class="btn btn-outline-secondary btn-sm btn-decrease">-</button>
                        <input type="number" 
                               class="form-control text-center quantity-input"
                               value="${item.cantidad}" 
                               min="1">
                        <button class="btn btn-outline-secondary btn-sm btn-increase">+</button>
                    </div>
                </td>

                <td class="unit-price" data-price="${item.precioUnitario}">S/. ${item.precioUnitario}</td>

                <td class="subtotal">
                    <c:set var="subtotal" value="${item.cantidad * item.precioUnitario}"/>
                    S/. <span class="subtotal-value">${subtotal}</span>
                    <c:set var="total" value="${total + subtotal}"/>
                </td>

                <td>
                    <button class="btn btn-danger btn-sm btn-delete">
                        <i class="fas fa-trash"></i> Eliminar
                    </button>
                </td>
            </tr>
        </c:forEach>
    </tbody>
            </table>
        </div>

        <div class="text-end">
            <h4>Total: <strong>S/. <span id="total-value">${total}</span></strong>
                <span id="sync-indicator" style="font-size: 0.85rem; margin-left: 10px;"></span>
            </h4>
            <a href="${pageContext.request.contextPath}/checkout" class="btn btn-accent mt-3">
                <i class="fas fa-credit-card"></i> Finalizar compra
            </a>
        </div>
    </c:if>
</div>
        <%@ include file="/jsp/includes/footer.jspf" %>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
(function() {
    'use strict';

    const updateTimeouts = {};
    const DEBOUNCE_DELAY = 2000;
    const $syncIndicator = $('#sync-indicator');

    function showSyncStatus(status) {
        if (status === 'syncing') {
            $syncIndicator.html('<i class="fas fa-circle-notch fa-spin text-warning"></i> Sincronizando...');
        } else if (status === 'synced') {
            $syncIndicator.html('<i class="fas fa-check-circle text-success"></i> Guardado');
            setTimeout(() => {
                $syncIndicator.html('');
            }, 2000);
        } else if (status === 'error') {
            $syncIndicator.html('<i class="fas fa-exclamation-circle text-danger"></i> Error');
        }
    }
// Agregar después de la función updateVisualTotals()
function updateCartBadge() {
    let totalItems = 0;
    
    $('#cart-table tbody tr').each(function() {
        const quantity = parseInt($(this).find('.quantity-input').val()) || 0;
        totalItems += quantity;
    });
    
    $('#cart-badge-count').text(totalItems);
}
    function updateVisualTotals() {
        let total = 0;

        $('#cart-table tbody tr').each(function() {
            const $row = $(this);
            const quantity = parseInt($row.find('.quantity-input').val()) || 0;
            const unitPrice = parseFloat($row.find('.unit-price').data('price')) || 0;
            const subtotal = quantity * unitPrice;

            $row.find('.subtotal-value').text(subtotal.toFixed(2));
            total += subtotal;
        });

        $('#total-value').text(total.toFixed(2));
    }

    function scheduleUpdate(idItem, cantidad) {
        if (updateTimeouts[idItem]) {
            clearTimeout(updateTimeouts[idItem]);
        }

        updateTimeouts[idItem] = setTimeout(() => {
            sendUpdateToServer(idItem, cantidad);
        }, DEBOUNCE_DELAY);
    }

    function sendUpdateToServer(idItem, cantidad) {
        showSyncStatus('syncing');

        $.ajax({
            url: "${pageContext.request.contextPath}/carrito",
            method: "POST",
            data: {
                accion: "actualizar",
                idItem: idItem,
                cantidad: cantidad
            },
            dataType: "json",
            success: function(resp) {
                if (resp.success) {
                    showSyncStatus('synced');
                } else {
                    showSyncStatus('error');
                    alert(resp.message || 'Error al actualizar el carrito');
                    location.reload();
                }
            },
            error: function() {
                showSyncStatus('error');
                alert('Error de conexión. Por favor, intenta nuevamente.');
            }
        });
    }

    $(document).on('click', '.btn-increase', function() {
        const $row = $(this).closest('tr');
        const idItem = $row.data('id');
        const $input = $row.find('.quantity-input');
        const newQuantity = parseInt($input.val()) + 1;

        $input.val(newQuantity);
        updateVisualTotals();
updateCartBadge();

        scheduleUpdate(idItem, newQuantity);
    });

    $(document).on('click', '.btn-decrease', function() {
        const $row = $(this).closest('tr');
        const idItem = $row.data('id');
        const $input = $row.find('.quantity-input');
        const currentQuantity = parseInt($input.val());

        if (currentQuantity <= 1) return;

        const newQuantity = currentQuantity - 1;
        $input.val(newQuantity);
        updateVisualTotals();
updateCartBadge();

        scheduleUpdate(idItem, newQuantity);
    });

    $(document).on('change', '.quantity-input', function() {
        const $row = $(this).closest('tr');
        const idItem = $row.data('id');
        let newQuantity = parseInt($(this).val());

        if (isNaN(newQuantity) || newQuantity < 1) {
            newQuantity = 1;
            $(this).val(1);
        }

        updateVisualTotals();
updateCartBadge();

        scheduleUpdate(idItem, newQuantity);
    });

    $(document).on('click', '.btn-delete', function() {
        if (!confirm('¿Eliminar este producto del carrito?')) return;

        const $row = $(this).closest('tr');
        const idItem = $row.data('id');

        $row.fadeOut(300, function() {
            $(this).remove();
            updateVisualTotals();
updateCartBadge();


            if ($('#cart-table tbody tr').length === 0) {
                $('#cart-table').closest('.table-responsive').remove();
                $('.text-end').remove();
                $('<div class="alert alert-info">Tu carrito está vacío.</div>')
                    .insertAfter('h1');
            }
        });

        showSyncStatus('syncing');
        $.ajax({
            url: "${pageContext.request.contextPath}/carrito",
            method: "POST",
            data: {
                accion: "eliminar",
                idItem: idItem
            },
            dataType: "json",
            success: function(resp) {
                if (resp.success) {
                    showSyncStatus('synced');
                } else {
                    showSyncStatus('error');
                    alert(resp.message || 'Error al eliminar el producto');
                    location.reload();
                }
            },
            error: function() {
                showSyncStatus('error');
                alert('Error de conexión.');
            }
        });
    });

})();
</script>

</body>
</html>