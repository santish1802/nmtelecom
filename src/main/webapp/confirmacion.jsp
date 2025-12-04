<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Compra Confirmada</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/custom-style.css">
    <style>
        .success-animation {
            animation: scaleIn 0.5s ease-out;
        }
        
        @keyframes scaleIn {
            0% {
                transform: scale(0);
                opacity: 0;
            }
            100% {
                transform: scale(1);
                opacity: 1;
            }
        }
        
        .success-icon {
            font-size: 5rem;
            color: #28a745;
            margin-bottom: 1rem;
        }
        
        .order-card {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 2rem;
            margin-top: 2rem;
        }
    </style>
</head>
<body>
<%@ include file="/jsp/includes/navbar.jspf" %>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8 text-center">
            <div class="success-animation">
                <i class="fas fa-check-circle success-icon"></i>
                
                <h1 class="mb-3">¡Compra Realizada con Éxito!</h1>
                <p class="lead text-muted">Gracias por tu compra. Tu pedido ha sido procesado y completado.</p>
            </div>

            <div class="order-card">
                <h4 class="mb-4">Detalles de tu Pedido</h4>
                
                <div class="row text-start">
                    <div class="col-md-6 mb-3">
                        <p class="mb-1"><strong>Número de Orden:</strong></p>
                        <p class="text-primary fs-5">${numeroOrden}</p>
                    </div>
                    
                    <div class="col-md-6 mb-3">
                        <p class="mb-1"><strong>Fecha:</strong></p>
                        <p class="fs-5">${fechaOrden}</p>
                    </div>
                    
                    <div class="col-md-6 mb-3">
                        <p class="mb-1"><strong>Estado:</strong></p>
                        <p><span class="badge bg-success fs-6">${estado}</span></p>
                    </div>
                    
                    <div class="col-md-6 mb-3">
                        <p class="mb-1"><strong>Total Pagado:</strong></p>
                        <p class="text-success fs-4 fw-bold">S/. ${total}</p>
                    </div>
                </div>
            </div>

            <div class="alert alert-info mt-4">
                <i class="fas fa-info-circle"></i>
                Tu pedido ha sido completado exitosamente. Recibirás una notificación pronto.
            </div>

            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-accent btn-lg me-2">
                    <i class="fas fa-shopping-bag"></i> Seguir Comprando
                </a>
                
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary btn-lg">
                    <i class="fas fa-home"></i> Ir al Inicio
                </a>
            </div>
        </div>
    </div>
</div>

<%@ include file="/jsp/includes/footer.jspf" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>