<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Detalle | ${producto.nombre}</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/custom-style.css"> 
        <style>
            .product-image-detail { max-width: 100%; height: auto; border-radius: 8px; }
            .description-text { 
                white-space: pre-wrap; /* Mantiene saltos de línea y espacios del texto de la DB */
                color: #495057; 
                line-height: 1.7;
            }
        </style>
    </head>
    <body>
        
        <%@ include file="/jsp/includes/navbar.jspf" %>

        <main class="container my-5">
            <div class="row">
                <div class="col-md-5">
                    <img src="${pageContext.request.contextPath}/images/${producto.codigo}.png" 
                         class="product-image-detail img-fluid" 
                         alt="${producto.nombre}"
                         onerror="this.src='${pageContext.request.contextPath}/images/placeholder.png'"/>
                </div>
                
                <div class="col-md-7">
                    
                    <c:choose>
                        <c:when test="${esServicio}">
                            <span class="badge bg-success-subtle text-success fs-6 mb-2">Servicio / Plan</span>
                            <h1>${producto.nombre}</h1>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-info-subtle text-info fs-6 mb-2">${producto.categoria}</span>
                            <h1>${producto.nombre}</h1>
                        </c:otherwise>
                    </c:choose>
                    
                    <h2 class="text-accent mb-4">
                        <fmt:setLocale value="es_PE"/>
                        S/. <fmt:formatNumber value="${producto.precio}" type="number" groupingUsed="true" minFractionDigits="2" maxFractionDigits="2"/>
                    </h2>
                    
                    <h3 class="mt-4 border-bottom pb-2">Descripción Detallada</h3>
                    <p class="description-text">${producto.descripcion}</p>
                    
                    <c:choose>
                        <c:when test="${esServicio}">
                            <div class="mt-4 d-grid gap-2">
                                <a href="#" class="btn btn-accent btn-lg"><i class="fas fa-bolt"></i> Contratar Ahora</a>
                                <a href="${pageContext.request.contextPath}/servicios" class="btn btn-outline-secondary">Volver a Servicios</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:if test="${producto.stock > 0}">
                                <div class="alert alert-success mt-4">
                                    <i class="fas fa-check-circle"></i> ${producto.stock} unidades en stock.
                                </div>
                                <div class="mt-4 d-flex gap-2">
                                    <button type="button" class="btn btn-accent btn-lg flex-grow-1" onclick="agregarAlCarrito(${producto.idProducto}, this)">
                                        <i class="fas fa-shopping-bag"></i> Agregar al Carrito
                                    </button>
                                </div>
                            </c:if>
                            <c:if test="${producto.stock <= 0}">
                                <div class="alert alert-danger mt-4">
                                    <i class="fas fa-ban"></i> Producto Agotado
                                </div>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/productos" class="btn btn-outline-secondary mt-3">Volver a Productos</a>
                        </c:otherwise>
                    </c:choose>

                </div>
            </div>
        </main>
        
        <%@ include file="/jsp/includes/footer.jspf" %>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        </body>
</html>