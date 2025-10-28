<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro | NM Telecom S.A.C.</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --nm-dark: #0b2f4f; /* Azul Oscuro (Primario) */
            --nm-accent: #38a798; /* Cian/Verde (Acento) */
        }
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #f0f4f8 0%, #e0e7ee 100%);
        }
        .register-container {
            max-width: 450px;
            padding: 30px;
            border-radius: 12px;
            background-color: white;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }
        .card-title {
            font-weight: 600;
            color: var(--nm-dark);
        }
        .btn-primary {
            background-color: var(--nm-accent);
            border-color: var(--nm-accent);
            font-weight: 500;
            transition: background-color 0.3s, border-color 0.3s;
        }
        .btn-primary:hover {
            background-color: #2c8c7c;
            border-color: #2c8c7c;
        }
        .form-control:focus {
            border-color: var(--nm-accent);
            box-shadow: 0 0 0 0.25rem rgba(56, 167, 152, 0.25); /* Color de acento con transparencia */
        }
    </style>
</head>
<body class="d-flex justify-content-center align-items-center min-vh-100">

    <div class="register-container">
        <h3 class="card-title text-center mb-4">
            <i class="fas fa-user-plus me-2"></i> Crear Cuenta
        </h3>
        
        <c:if test="${not empty mensaje}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${mensaje}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/registro" method="POST">
            
            <div class="mb-3">
                <label for="nombreUsuario" class="form-label">
                    <i class="fas fa-user me-1"></i> Nombre de Usuario
                </label>
                <input type="text" class="form-control" id="nombreUsuario" name="nombreUsuario" 
                       placeholder="ej. mi_usuario_nm" required>
            </div>
            
            <div class="mb-3">
                <label for="email" class="form-label">
                    <i class="fas fa-envelope me-1"></i> Email
                </label>
                <input type="email" class="form-control" id="email" name="email" 
                       placeholder="ej. correo@dominio.com" required>
            </div>
            
            <div class="mb-4">
                <label for="password" class="form-label">
                    <i class="fas fa-lock me-1"></i> Contraseña
                </label>
                <input type="password" class="form-control" id="password" name="password" 
                       placeholder="Ingresa tu contraseña (min 6 caracteres)" required minlength="6">
            </div>
            
            <button type="submit" class="btn btn-primary w-100 mb-3">
                <i class="fas fa-arrow-right-to-bracket me-1"></i> Registrarse
            </button>
            
        </form>
        
        <p class="mt-3 text-center text-muted">
            ¿Ya tienes cuenta? <a href="${pageContext.request.contextPath}/login" class="text-decoration-none" style="color: var(--nm-accent);">Iniciar Sesión</a>
        </p>
        <p class="text-center">
            <a href="${pageContext.request.contextPath}/catalogo" class="text-decoration-none text-secondary">
                <i class="fas fa-home me-1"></i> Volver al Catálogo
            </a>
        </p>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>