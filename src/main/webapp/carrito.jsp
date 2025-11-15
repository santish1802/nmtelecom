<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mi Carrito</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
    /* ============================================
       HERO SECTION - reutilizado del catálogo
       ============================================ */
    .hero-section {
        background: linear-gradient(135deg, var(--nm-dark, #0a0a0a) 0%, var(--nm-dark-lighter, #1c1c1c) 100%);
        padding: 4rem 0 3rem;
        margin-bottom: 3rem;
        position: relative;
        overflow: hidden;
        color: white;
    }

    .hero-section::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: url('data:image/svg+xml,<svg width="100" height="100" xmlns="http://www.w3.org/2000/svg"><defs><pattern id="grid" width="100" height="100" patternUnits="userSpaceOnUse"><path d="M 100 0 L 0 0 0 100" fill="none" stroke="rgba(43,165,160,0.05)" stroke-width="1"/></pattern></defs><rect width="100%" height="100%" fill="url(%23grid)"/></svg>');
        opacity: 0.3;
    }

    .hero-content {
        position: relative;
        z-index: 1;
    }

    .page-title {
        font-weight: 300;
        letter-spacing: 1px;
        color: var(--nm-white, #fff);
        margin-bottom: 0.5rem;
        font-size: 2.75rem;
        text-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .page-subtitle {
        color: var(--nm-accent, #2ba5a0);
        font-size: 1.1rem;
        font-weight: 400;
        opacity: 0.95;
    }

    @media (max-width: 768px) {
        .hero-section {
            padding: 3rem 0 2rem;
        }

        .page-title {
            font-size: 2rem;
        }

        .page-subtitle {
            font-size: 1rem;
        }
    }
</style>
</head>
<body>
<%@ include file="/jsp/includes/navbar.jspf" %>
<section class="hero-section">
<div class="container">
     <div class="hero-content text-center">
            <h1 class="page-title">🛍️ Mi Carrito</h1>
            <p class="page-subtitle">Revisa tus productos antes de finalizar la compra</p>
        </div>

    <c:if test="${empty items}">
        <div class="alert alert-info">Tu carrito está vacío.</div>
    </c:if>

    <c:if test="${not empty items}">
        <table class="table table-hover align-middle">
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
        <tr data-id="${item.idProducto}">
            <td>${item.nombre}</td>

            <!-- Cantidad con botón -->
            <td>
                <div class="input-group input-group-sm" style="max-width: 120px;">
                    <button class="btn btn-outline-secondary btn-sm" onclick="cambiarCantidad(${item.idProducto}, ${item.cantidad - 1})">-</button>
                    <input type="number" class="form-control text-center" value="${item.cantidad}" min="1" onchange="actualizarCantidad(${item.idProducto}, this.value)">
                    <button class="btn btn-outline-secondary btn-sm" onclick="cambiarCantidad(${item.idProducto}, ${item.cantidad + 1})">+</button>
                </div>
            </td>

            <td>S/. ${item.precioUnitario}</td>

            <td>
                <c:set var="subtotal" value="${item.cantidad * item.precioUnitario}"/>
                S/. ${subtotal}
                <c:set var="total" value="${total + subtotal}"/>
            </td>

            <td>
                <button class="btn btn-danger btn-sm" onclick="eliminarProducto(${item.idProducto})">
                    <i class="fas fa-trash"></i> Eliminar
                </button>
            </td>
        </tr>
    </c:forEach>
</tbody>
        </table>

        <div class="text-end">
            <h4>Total: <strong>S/. ${total}</strong></h4>
            <a href="${pageContext.request.contextPath}/checkout" class="btn btn-success mt-3">
                <i class="fas fa-credit-card"></i> Finalizar compra
            </a>
        </div>
    </c:if>
</div>
</section>
</body>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    function actualizarCantidad(idProducto, nuevaCantidad) {
        if (nuevaCantidad < 1) return;

        $.post("${pageContext.request.contextPath}/carrito", {
            accion: "actualizar",
            idProducto: idProducto,
            cantidad: nuevaCantidad
        }, function(resp) {
            if (resp.success) {
                location.reload();
            } else {
                alert(resp.message);
            }
        }, "json");
    }

    function cambiarCantidad(idProducto, nuevaCantidad) {
        if (nuevaCantidad < 1) return;
        actualizarCantidad(idProducto, nuevaCantidad);
    }

    function eliminarProducto(idProducto) {
        if (!confirm("¿Eliminar este producto del carrito?")) return;

        $.post("${pageContext.request.contextPath}/carrito", {
            accion: "eliminar",
            idProducto: idProducto
        }, function(resp) {
            if (resp.success) {
                location.reload();
            } else {
                alert(resp.message);
            }
        }, "json");
    }
</script>

</html>
