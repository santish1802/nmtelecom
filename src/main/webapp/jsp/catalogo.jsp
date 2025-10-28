<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Catálogo de productos tecnológicos - NM Telecom">
        <title>Catálogo de Productos | NM Telecom S.A.C.</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/custom-style.css">

        <style>
            /* ============================================
               ESTILOS ESPECÍFICOS DEL CATÁLOGO
               ============================================ */

            /* Hero Section */
            .btn-icon-cart {
                width: 45px;
                padding: 0.5rem;
            }
            .hero-section {
                background: linear-gradient(135deg, var(--nm-dark) 0%, var(--nm-dark-lighter) 100%);
                padding: 4rem 0 3rem;
                margin-bottom: 3rem;
                position: relative;
                overflow: hidden;
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
                color: var(--nm-white);
                margin-bottom: 0.5rem;
                font-size: 2.75rem;
                text-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .page-subtitle {
                color: var(--nm-accent);
                font-size: 1.1rem;
                font-weight: 400;
                opacity: 0.95;
            }

            /* Product Cards */
            .product-card {
                position: relative;
                height: 100%;
            }

            .product-image-wrapper {
                position: relative;
                overflow: hidden;
                border-radius: 16px 16px 0 0;
                background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            }

            .stock-badge {
                position: absolute;
                top: 1rem;
                right: 1rem;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                padding: 0.4rem 0.8rem;
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: 600;
                color: var(--nm-accent);
                box-shadow: var(--shadow-sm);
                z-index: 2;
            }

            .stock-badge.out-of-stock {
                background: rgba(220, 53, 69, 0.95);
                color: white;
            }

            .product-name {
                min-height: 3rem;
                font-weight: 600;
                font-size: 1.1rem;
                line-height: 1.4;
                color: var(--nm-dark);
                margin-bottom: 0.5rem;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
            }

            .product-category {
                display: inline-block;
                background: var(--nm-accent-light);
                color: var(--nm-accent);
                padding: 0.25rem 0.75rem;
                border-radius: 20px;
                font-size: 0.8rem;
                font-weight: 500;
                margin-bottom: 1rem;
            }

            .product-price {
                color: var(--nm-accent);
                font-size: 1.75rem;
                font-weight: 700;
                margin-bottom: 1rem;
                letter-spacing: -0.5px;
            }

            .price-label {
                font-size: 0.8rem;
                color: var(--nm-medium-gray);
                font-weight: 400;
                display: block;
                margin-bottom: 0.25rem;
            }

            /* Empty State */
            .empty-state {
                text-align: center;
                padding: 5rem 2rem;
            }

            .empty-state-icon {
                font-size: 5rem;
                color: var(--nm-gray);
                margin-bottom: 1.5rem;
                opacity: 0.5;
            }

            .empty-state-title {
                font-size: 1.5rem;
                color: var(--nm-dark);
                margin-bottom: 0.5rem;
                font-weight: 600;
            }

            .empty-state-text {
                color: var(--nm-medium-gray);
                font-size: 1rem;
            }

            /* Loading Animation */
            .loading-spinner {
                display: inline-block;
                width: 40px;
                height: 40px;
                border: 4px solid var(--nm-gray);
                border-top-color: var(--nm-accent);
                border-radius: 50%;
                animation: spin 1s linear infinite;
            }

            @keyframes spin {
                to {
                    transform: rotate(360deg);
                }
            }

            /* Responsive Adjustments */
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

        <!-- Navbar -->
        <%@ include file="/jsp/includes/navbar.jspf" %>


        <!-- Toast Container -->
        <div class="toast-container position-fixed top-0 end-0 p-3" style="z-index: 9999; margin-top: 70px;">
            <div id="cartToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="toast-header">
                    <i class="fas fa-shopping-cart me-2" id="toast-icon"></i>
                    <strong class="me-auto" id="toast-title">Carrito</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="toast"></button>
                </div>
                <div class="toast-body" id="toast-message"></div>
            </div>
        </div>
        <!-- Hero Section -->
        <section class="hero-section">
            <div class="container">
                <div class="hero-content text-center">
                    <h1 class="page-title">Elige el producto a tu necesidad</h1>
                    <p class="page-subtitle">Tecnología de vanguardia con la mejor calidad y precio</p>
                </div>
            </div>
        </section>

        <!-- Catalog Section -->
        <main class="container mb-5">
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">

                <c:forEach var="producto" items="${productos}">
                    <div class="col">
                        <div class="card product-card">
                            <div class="product-image-wrapper">
                                <c:choose>
                                    <c:when test="${producto.stock > 0}">
                                        <span class="stock-badge">
                                            <i class="fas fa-check-circle"></i> Disponible
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="stock-badge out-of-stock">
                                            <i class="fas fa-times-circle"></i> Agotado
                                        </span>
                                    </c:otherwise>
                                </c:choose>

                                <img src="${pageContext.request.contextPath}/images/${producto.codigo}.png" 
                                     class="card-img-top" 
                                     alt="${producto.nombre}"
                                     onerror="this.src='${pageContext.request.contextPath}/images/placeholder.png'"/>
                            </div>

                            <div class="card-body d-flex flex-column">
                                <h5 class="product-name">${producto.nombre}</h5>
                                <span class="product-category">
                                    <i class="fas fa-tag"></i> ${producto.categoria}
                                </span>

                                <div class="mt-auto">
                                    <span class="price-label">Precio:</span>
                                    <h4 class="product-price">
                                        <fmt:setLocale value="es_PE"/>
                                        S/. <fmt:formatNumber value="${producto.precio}" type="number" groupingUsed="true" minFractionDigits="2" maxFractionDigits="2"/>
                                    </h4>

                                    <c:choose>
                                        <c:when test="${producto.stock > 0}">
                                            <div class="d-flex gap-2">
                                                <button type="button" 
                                                        class="btn btn-accent flex-grow-1 btn-comprar"
                                                        onclick="agregarAlCarrito(${producto.idProducto}, this)">
                                                    <i class="fas fa-shopping-bag"></i> Comprar
                                                </button>
                                                <button type="button" 
                                                        class="btn btn-outline-secondary btn-icon-cart" 
                                                        onclick="agregarAlCarrito(${producto.idProducto}, this)"
                                                        title="Agregar al carrito">
                                                    <i class="fas fa-cart-plus"></i>
                                                </button>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-secondary disabled w-100" disabled>
                                                <i class="fas fa-ban"></i> Sin Stock
                                            </button>
                                        </c:otherwise>
                                    </c:choose>

                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <!-- Empty State -->
                <c:if test="${empty productos}">
                    <div class="col-12">
                        <div class="empty-state">
                            <div class="empty-state-icon">
                                <i class="fas fa-box-open"></i>
                            </div>
                            <h3 class="empty-state-title">No hay productos disponibles</h3>
                            <p class="empty-state-text">
                                Lo sentimos, actualmente no tenemos productos en el catálogo.<br>
                                Vuelve pronto para ver nuestras novedades.
                            </p>
                        </div>
                    </div>
                </c:if>

            </div>
        </main>

        <!-- Footer Premium -->
        <%@ include file="/jsp/includes/footer.jspf" %>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // ===========================================
    // Función para actualizar badge del carrito
    // ===========================================
    function updateCartBadge(count) {
        let badge = $('#cart-badge-count');
        if (count > 0) {
            badge.text(count).removeClass('d-none');
        } else {
            badge.text(0).addClass('d-none');
        }
    }

    // ===========================================
    // Función para mostrar Toast
    // ===========================================
    function showToast(message, type = 'success') {
        const toastEl = $('#cartToast');
        const toastIcon = $('#toast-icon');
        const toastTitle = $('#toast-title');
        const toastMessage = $('#toast-message');
        
        toastMessage.text(message);
        
        // Cambiar el ícono y título según el tipo
        toastIcon.removeClass('fa-shopping-cart fa-exclamation-triangle fa-times-circle text-success text-danger text-warning');
        
        if (type === 'success') {
            toastIcon.addClass('fa-shopping-cart text-success');
            toastTitle.text('¡Éxito!');
        } else if (type === 'error') {
            toastIcon.addClass('fa-times-circle text-danger');
            toastTitle.text('Error');
        } else if (type === 'warning') {
            toastIcon.addClass('fa-exclamation-triangle text-warning');
            toastTitle.text('Aviso');
        }
        
        const toast = new bootstrap.Toast(toastEl);
        toast.show();
    }

    // ===========================================
    // Función para agregar al carrito (AJAX)
    // ===========================================
    function agregarAlCarrito(idProducto, btnElement) {
        const $btn = $(btnElement);
        const originalHtml = $btn.html();
        
        // Deshabilitar botón y mostrar loading
        $btn.prop('disabled', true);
        if ($btn.hasClass('btn-comprar')) {
            $btn.html('<span class="spinner-border spinner-border-sm" role="status"></span> Agregando...');
        } else {
            $btn.html('<span class="spinner-border spinner-border-sm" role="status"></span>');
        }
        
        $.ajax({
            type: 'POST',
            url: '${pageContext.request.contextPath}/carrito',
            data: {
                idProducto: idProducto,
                accion: 'agregar'
            },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    // Actualizar badge del carrito
                    updateCartBadge(response.count);
                    
                    // Mostrar toast de éxito
                    showToast(response.message || 'Producto agregado al carrito', 'success');
                } else {
                    // Verificar si requiere login
                    if (response.requireLogin) {
                        showToast('Debe iniciar sesión para agregar productos', 'warning');
                        setTimeout(() => {
                            window.location.href = '${pageContext.request.contextPath}/login';
                        }, 1500);
                    } else {
                        showToast(response.message || 'No se pudo agregar al carrito', 'error');
                    }
                }
            },
            error: function() {
                showToast('Error de conexión con el servidor', 'error');
            },
            complete: function() {
                // Restaurar botón
                $btn.prop('disabled', false);
                $btn.html(originalHtml);
            }
        });
    }

    // ===========================================
    // Document Ready
    // ===========================================
    $(document).ready(function() {
        // Smooth scroll
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function(e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({behavior: 'smooth', block: 'start'});
                }
            });
        });

        // Animación de entrada para las cards
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, {threshold: 0.1});

        document.querySelectorAll('.card').forEach(card => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
            observer.observe(card);
        });
    });
</script>
    </body>
</html>