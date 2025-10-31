<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin | ${titulo}</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/custom-style.css">
    </head>
    <body>

        <%@ include file="/jsp/includes/navbar.jspf" %>

        <main class="container my-5">
            <h1 class="mb-4">${titulo}</h1>

            <div class="card shadow-sm">
                <div class="card-body">
                    
                    <%-- El enctype="multipart/form-data" es crucial para el manejo de archivos --%>
                    <form action="${pageContext.request.contextPath}/admin/productos/guardar" method="POST" enctype="multipart/form-data">
                        
                        <%-- Campo Oculto para ID (si es edición) --%>
                        <input type="hidden" name="idProducto" value="${producto.idProducto}">
                        
                        <div class="row g-3">
                            
                            <div class="col-md-6">
                                <h4 class="mb-3">Información General</h4>
                                
                                <div class="mb-3">
                                    <label for="nombre" class="form-label">Nombre del Ítem</label>
                                    <input type="text" class="form-control" id="nombre" name="nombre" value="${producto.nombre}" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="codigo" class="form-label">Código (SKU)</label>
                                    <input type="text" class="form-control" id="codigo" name="codigo" value="${producto.codigo}" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="precio" class="form-label">Precio (S/.)</label>
                                    <input type="number" class="form-control" id="precio" name="precio" step="0.01" value="${producto.precio}" required>
                                </div>

                                <div class="mb-3">
                                    <label for="categoria" class="form-label">Categoría</label>
                                    <select class="form-select" id="categoria" name="categoria" required onchange="toggleStockField(this.value)">
                                        <option value="">Seleccione una categoría</option>
                                        <c:forEach var="cat" items="${categorias}">
                                            <option value="${cat}" ${producto.categoria == cat ? 'selected' : ''}>${cat}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                
                                <div class="mb-3" id="stock-field">
                                    <label for="stock" class="form-label">Stock Actual</label>
                                    <input type="number" class="form-control" id="stock" name="stock" value="${producto.stock != null ? producto.stock : 0}">
                                </div>
                                
                                <div class="mb-3 form-check">
                                    <input type="checkbox" class="form-check-input" id="activo" name="activo" value="true" ${producto.activo || producto.idProducto == null ? 'checked' : ''}>
                                    <label class="form-check-label" for="activo">Ítem Activo (Visible)</label>
                                </div>
                                
                            </div>
                            
                            <div class="col-md-6">
                                <h4 class="mb-3">Detalles y Medios</h4>

                                <div class="mb-3">
                                    <label for="descripcion" class="form-label">Descripción Detallada</label>
                                    <textarea class="form-control" id="descripcion" name="descripcion" rows="8" required>${producto.descripcion}</textarea>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="imagenFile" class="form-label">Imagen del Ítem (PNG/JPG)</label>
                                    <input class="form-control" type="file" id="imagenFile" name="imagenFile">
                                    <div class="form-text">La imagen se guardará como **`${producto.codigo}.png/jpg`** en la carpeta `/images/`.</div>
                                </div>

                                <c:if test="${producto.idProducto != null}">
                                    <div class="mb-3">
                                        <label class="form-label">Imagen Actual</label>
                                        <img src="${pageContext.request.contextPath}/images/${producto.codigo}.png" 
                                             class="img-thumbnail" 
                                             style="max-width: 150px;"
                                             onerror="this.src='${pageContext.request.contextPath}/images/placeholder.png'"/>
                                    </div>
                                </c:if>
                                
                            </div>
                        </div>

                        <hr class="my-4">
                        
                        <div class="d-flex justify-content-end gap-2">
                            <a href="${pageContext.request.contextPath}/admin/productos" class="btn btn-outline-secondary">
                                <i class="fas fa-times"></i> Cancelar
                            </a>
                            <button type="submit" class="btn btn-accent btn-lg">
                                <i class="fas fa-save"></i> Guardar Cambios
                            </button>
                        </div>
                    </form>
                    
                </div>
            </div>
            
        </main>

        <%@ include file="/jsp/includes/footer.jspf" %>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        
        <script>
            // Oculta el campo de Stock si es un Servicio/Plan
            function toggleStockField(categoria) {
                const stockField = document.getElementById('stock-field');
                if (categoria === 'Servicios' || categoria === 'Plan') {
                    stockField.style.display = 'none';
                    // Es importante que el campo stock se envíe con 0 si está oculto
                    document.getElementById('stock').value = 0; 
                } else {
                    stockField.style.display = 'block';
                }
            }
            
            // Ejecutar al cargar la página
            document.addEventListener('DOMContentLoaded', function() {
                const categoriaSelect = document.getElementById('categoria');
                toggleStockField(categoriaSelect.value);
            });
        </script>
    </body>
</html>