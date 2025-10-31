<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin | Gestión de Productos</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/custom-style.css">
    </head>
    <body>

        <%@ include file="/jsp/includes/navbar.jspf" %>

        <main class="container my-5">
            <h1 class="mb-4">Gestión de Productos y Servicios (CRUD)</h1>

            <div class="d-flex justify-content-between mb-4">
                <p>Lista de ítems: todos los campos están siendo manejados directamente en el Controller.</p>
                <a href="${pageContext.request.contextPath}/admin/productos/nuevo" class="btn btn-accent">
                    <i class="fas fa-plus-circle"></i> Crear Nuevo Ítem
                </a>
            </div>

            <c:if test="${not empty mensaje}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${mensaje}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div class="table-responsive">
                <table class="table table-striped table-hover align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Código</th>
                            <th>Nombre</th>
                            <th>Categoría</th>
                            <th>Precio</th>
                            <th>Stock</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${productos}">
                            <tr class="${p.activo ? '' : 'table-danger'}">
                                <td>${p.idProducto}</td>
                                <td>${p.codigo}</td>
                                <td><a href="${pageContext.request.contextPath}/producto/detalle/${p.idProducto}" target="_blank">${p.nombre}</a></td>
                                <td>${p.categoria}</td>
                                <td>
                                    <fmt:setLocale value="es_PE"/>
                                    S/. <fmt:formatNumber value="${p.precio}" type="number" groupingUsed="true" minFractionDigits="2" maxFractionDigits="2"/>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.categoria == 'Servicios' || p.categoria == 'Plan'}">
                                            N/A
                                        </c:when>
                                        <c:otherwise>
                                            ${p.stock}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="badge bg-${p.activo ? 'success' : 'danger'}">
                                        ${p.activo ? 'Activo' : 'Inactivo'}
                                    </span>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/productos/editar/${p.idProducto}" class="btn btn-sm btn-info" title="Editar">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/productos/eliminar/${p.idProducto}" 
                                       class="btn btn-sm btn-warning" 
                                       title="Desactivar"
                                       onclick="return confirm('¿Estás seguro de desactivar el ítem ${p.nombre}?');">
                                        <i class="fas fa-toggle-off"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            
            <c:if test="${empty productos}">
                <div class="alert alert-warning text-center mt-5" role="alert">
                    No se encontraron ítems en la base de datos.
                </div>
            </c:if>

        </main>

        <%@ include file="/jsp/includes/footer.jspf" %>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>