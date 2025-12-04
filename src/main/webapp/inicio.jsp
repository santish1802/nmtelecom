<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="com.utp.nmtelecom.util.DatabaseConnection"%>
<%@page import="java.util.*"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
    // Obtener productos destacados desde la base de datos
    List<Map<String, Object>> productosDestacados = new ArrayList<>();
    
    String sqlProductos = "SELECT idProducto, codigo, nombre, precio, categoria, stock FROM producto WHERE activo = 1 LIMIT 6";
    
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sqlProductos);
         ResultSet rs = ps.executeQuery()) {
        
        while (rs.next()) {
            Map<String, Object> producto = new HashMap<>();
            producto.put("idProducto", rs.getLong("idProducto"));
            producto.put("codigo", rs.getString("codigo"));
            producto.put("nombre", rs.getString("nombre"));
            producto.put("precio", rs.getDouble("precio"));
            producto.put("categoria", rs.getString("categoria"));
            producto.put("stock", rs.getInt("stock"));
            productosDestacados.add(producto);
        }
        
    } catch (SQLException e) {
        e.printStackTrace();
    }
    
    request.setAttribute("productosDestacados", productosDestacados);
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NM Telecom - Soluciones Tecnológicas Inteligentes</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/custom-style.css">
    <style>
        :root {
            --nm-dark: #0b2f4f;
            --nm-accent: #38a798;
            --nm-white: #ffffff;
            --nm-light-gray: #f8f9fa;
        }
        h1, h2, h3 {
            color: white;
        }
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            overflow-x: hidden;
        }

        /* ============================================
           HERO SLIDER
           ============================================ */
        .hero-slider {
            position: relative;
            height: 100vh;
            overflow: hidden;
        }

        .hero-slide {
            position: relative;
            height: 100vh;
            display: flex;
            align-items: center;
            background: linear-gradient(135deg, var(--nm-dark) 0%, #0a1f35 100%);
        }

        .hero-slide::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg width="100" height="100" xmlns="http://www.w3.org/2000/svg"><defs><pattern id="grid" width="100" height="100" patternUnits="userSpaceOnUse"><path d="M 100 0 L 0 0 0 100" fill="none" stroke="rgba(56,167,152,0.05)" stroke-width="1"/></pattern></defs><rect width="100%" height="100%" fill="url(%23grid)"/></svg>');
            opacity: 0.3;
        }

        .hero-content {
            position: relative;
            z-index: 2;
            color: white;
            max-width: 800px;
        }

        .hero-content h1 {
            font-size: 4rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            line-height: 1.2;
            animation: fadeInUp 1s ease;
        }

        .hero-content .highlight {
            color: var(--nm-accent);
        }

        .hero-content p {
            font-size: 1.5rem;
            margin-bottom: 2rem;
            opacity: 0.9;
            animation: fadeInUp 1s ease 0.2s both;
        }

        .hero-buttons {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            animation: fadeInUp 1s ease 0.4s both;
        }

        .btn-hero-primary {
            background: var(--nm-accent);
            color: white;
            padding: 1rem 2.5rem;
            font-size: 1.1rem;
            font-weight: 600;
            border: none;
            border-radius: 50px;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-hero-primary:hover {
            background: #2d8a7e;
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(56, 167, 152, 0.3);
            color: white;
        }

        .btn-hero-secondary {
            background: transparent;
            color: white;
            padding: 1rem 2.5rem;
            font-size: 1.1rem;
            font-weight: 600;
            border: 2px solid white;
            border-radius: 50px;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-hero-secondary:hover {
            background: white;
            color: var(--nm-dark);
            transform: translateY(-3px);
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* ============================================
           SOBRE NOSOTROS
           ============================================ */
        .about-section {
            padding: 5rem 0;
            background: white;
            position: relative;
        }

        .section-title {
            text-align: center;
            margin-bottom: 3rem;
        }

        .section-title h2 {
            font-size: 3rem;
            color: var(--nm-dark);
            font-weight: 700;
            margin-bottom: 1rem;
        }

        .section-title .underline {
            width: 100px;
            height: 4px;
            background: var(--nm-accent);
            margin: 0 auto;
            border-radius: 2px;
        }

        .about-content {
            max-width: 900px;
            margin: 0 auto;
            text-align: center;
        }

        .about-content p {
            font-size: 1.2rem;
            color: #555;
            line-height: 1.8;
            margin-bottom: 2rem;
        }

        .vision-mission {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-top: 3rem;
        }

        .vm-card {
            background: linear-gradient(135deg, var(--nm-dark), #0a1f35);
            padding: 2.5rem;
            border-radius: 15px;
            color: white;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .vm-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg width="100" height="100" xmlns="http://www.w3.org/2000/svg"><defs><pattern id="grid2" width="100" height="100" patternUnits="userSpaceOnUse"><path d="M 100 0 L 0 0 0 100" fill="none" stroke="rgba(56,167,152,0.05)" stroke-width="1"/></pattern></defs><rect width="100%" height="100%" fill="url(%23grid2)"/></svg>');
            opacity: 0.3;
        }

        .vm-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(11, 47, 79, 0.3);
        }

        .vm-card i {
            font-size: 3rem;
            color: var(--nm-accent);
            margin-bottom: 1.5rem;
            position: relative;
            z-index: 1;
        }

        .vm-card h3 {
            font-size: 1.8rem;
            margin-bottom: 1rem;
            position: relative;
            z-index: 1;
        }

        .vm-card p {
            font-size: 1.1rem;
            opacity: 0.9;
            line-height: 1.6;
            position: relative;
            z-index: 1;
        }

        /* ============================================
           PRODUCTOS DESTACADOS
           ============================================ */
        .products-section {
            padding: 5rem 0;
            background: var(--nm-light-gray);
        }

        .product-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .product-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
        }

        .product-image {
            background: linear-gradient(135deg, var(--nm-dark), #0a1f35);
            height: 200px;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        .product-image::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg width="100" height="100" xmlns="http://www.w3.org/2000/svg"><defs><pattern id="grid3" width="100" height="100" patternUnits="userSpaceOnUse"><path d="M 100 0 L 0 0 0 100" fill="none" stroke="rgba(56,167,152,0.05)" stroke-width="1"/></pattern></defs><rect width="100%" height="100%" fill="url(%23grid3)"/></svg>');
            opacity: 0.3;
        }

        .product-image i {
            font-size: 4rem;
            color: var(--nm-accent);
            position: relative;
            z-index: 1;
        }

        .product-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: var(--nm-accent);
            color: white;
            padding: 0.4rem 0.8rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            z-index: 2;
        }

        .product-body {
            padding: 1.5rem;
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .product-category {
            color: var(--nm-accent);
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            text-transform: uppercase;
        }

        .product-title {
            font-size: 1.3rem;
            color: var(--nm-dark);
            font-weight: 700;
            margin-bottom: 1rem;
        }

        .product-price {
            font-size: 2rem;
            color: var(--nm-dark);
            font-weight: 700;
            margin-bottom: 1rem;
        }

        .product-price small {
            font-size: 1rem;
            color: #999;
            font-weight: 400;
        }

        .product-stock {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }

        .product-stock.in-stock {
            color: #28a745;
        }

        .product-stock.low-stock {
            color: #ffc107;
        }

        .btn-product {
            background: var(--nm-dark);
            color: white;
            padding: 0.8rem;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            margin-top: auto;
            text-decoration: none;
            display: block;
            text-align: center;
        }

        .btn-product:hover {
            background: var(--nm-accent);
            transform: translateY(-2px);
            color: white;
        }

        /* ============================================
           CTA SECTION
           ============================================ */
        .cta-section {
            background: linear-gradient(135deg, var(--nm-dark) 0%, #0a1f35 100%);
            padding: 5rem 0;
            position: relative;
            overflow: hidden;
        }

        .cta-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg width="100" height="100" xmlns="http://www.w3.org/2000/svg"><defs><pattern id="grid4" width="100" height="100" patternUnits="userSpaceOnUse"><path d="M 100 0 L 0 0 0 100" fill="none" stroke="rgba(56,167,152,0.05)" stroke-width="1"/></pattern></defs><rect width="100%" height="100%" fill="url(%23grid4)"/></svg>');
            opacity: 0.3;
        }

        .cta-content {
            position: relative;
            z-index: 1;
            text-align: center;
            color: white;
        }

        .cta-content h2 {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
        }

        .cta-content p {
            font-size: 1.3rem;
            margin-bottom: 2.5rem;
            opacity: 0.9;
        }

        /* ============================================
           FOOTER
           ============================================ */
        footer {
            background: #0a1f35;
            color: white;
            padding: 3rem 0 1rem;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .footer-section h4 {
            color: var(--nm-accent);
            margin-bottom: 1rem;
            font-size: 1.3rem;
        }

        .footer-section p,
        .footer-section a {
            color: rgba(255,255,255,0.8);
            text-decoration: none;
            display: block;
            margin-bottom: 0.5rem;
            transition: color 0.3s ease;
        }

        .footer-section a:hover {
            color: var(--nm-accent);
        }

        .social-links {
            display: flex;
            gap: 1rem;
            margin-top: 1rem;
        }

        .social-links a {
            width: 40px;
            height: 40px;
            background: var(--nm-accent);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .social-links a:hover {
            background: white;
            color: var(--nm-dark);
            transform: translateY(-3px);
        }

        .footer-bottom {
            border-top: 1px solid rgba(255,255,255,0.1);
            padding-top: 2rem;
            text-align: center;
            color: rgba(255,255,255,0.6);
        }

        /* ============================================
           RESPONSIVE
           ============================================ */
        @media (max-width: 768px) {
            .hero-content h1 {
                font-size: 2.5rem;
            }

            .hero-content p {
                font-size: 1.2rem;
            }

            .section-title h2 {
                font-size: 2rem;
            }

            .hero-buttons {
                flex-direction: column;
            }

            .btn-hero-primary,
            .btn-hero-secondary {
                text-align: center;
                width: 100%;
            }

            .cta-content h2 {
                font-size: 2rem;
            }

            .cta-content p {
                font-size: 1.1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <%@ include file="/jsp/includes/navbar.jspf" %>

    <!-- Hero Slider -->
    <section class="hero-slider">
        <div id="heroCarousel" class="carousel slide" data-bs-ride="carousel">
            <div class="carousel-indicators">
                <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="0" class="active"></button>
                <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="1"></button>
                <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="2"></button>
            </div>
            
            <div class="carousel-inner">
                <!-- Slide 1 -->
                <div class="carousel-item active">
                    <div class="hero-slide">
                        <div class="container">
                            <div class="hero-content">
                                <h1>Soluciones <span class="highlight">Tecnológicas</span> Inteligentes</h1>
                                <p>Impulsamos tu crecimiento digital con innovación y excelencia</p>
                                <div class="hero-buttons">
                                    <a href="${pageContext.request.contextPath}/catalogo" class="btn-hero-primary">
                                        <i class="fas fa-shopping-cart me-2"></i> Ver Catálogo
                                    </a>
                                    <a href="#about" class="btn-hero-secondary">
                                        <i class="fas fa-info-circle me-2"></i> Conocer Más
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Slide 2 -->
                <div class="carousel-item">
                    <div class="hero-slide">
                        <div class="container">
                            <div class="hero-content">
                                <h1>Tu <span class="highlight">Transformación Digital</span> Empieza Aquí</h1>
                                <p>Productos y servicios de alta calidad para tu negocio</p>
                                <div class="hero-buttons">
                                    <a href="${pageContext.request.contextPath}/catalogo" class="btn-hero-primary">
                                        <i class="fas fa-rocket me-2"></i> Comenzar Ahora
                                    </a>
                                    <a href="#products" class="btn-hero-secondary">
                                        <i class="fas fa-box me-2"></i> Ver Productos
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Slide 3 -->
                <div class="carousel-item">
                    <div class="hero-slide">
                        <div class="container">
                            <div class="hero-content">
                                <h1><span class="highlight">Innovación</span> y Tecnología</h1>
                                <p>Líderes en implementación de soluciones web eficientes</p>
                                <div class="hero-buttons">
                                    <a href="${pageContext.request.contextPath}/catalogo" class="btn-hero-primary">
                                        <i class="fas fa-store me-2"></i> Explorar Tienda
                                    </a>
                                    <a href="#about" class="btn-hero-secondary">
                                        <i class="fas fa-users me-2"></i> Nuestro Equipo
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
                <span class="carousel-control-prev-icon"></span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
                <span class="carousel-control-next-icon"></span>
            </button>
        </div>
    </section>

    <!-- Sobre Nosotros -->
    <section id="about" class="about-section">
        <div class="container">
            <div class="section-title">
                <h2>Sobre Nosotros</h2>
                <div class="underline"></div>
            </div>

            <div class="about-content">
                <p>
                    Impulsamos tu crecimiento con soluciones tecnológicas inteligentes. 
                    En un mundo cada vez más digital, contar con una presencia web ya no es una opción, 
                    sino una necesidad.
                </p>

                <div class="vision-mission">
                    <div class="vm-card">
                        <i class="fas fa-eye"></i>
                        <h3>Visión</h3>
                        <p>
                            Ser una empresa líder en la implementación de soluciones tecnológicas innovadoras, 
                            facilitando la transformación digital de nuestros clientes mediante plataformas web eficientes.
                        </p>
                    </div>

                    <div class="vm-card">
                        <i class="fas fa-bullseye"></i>
                        <h3>Misión</h3>
                        <p>
                            Ofrecer productos y servicios tecnológicos de alta calidad que respondan a las necesidades 
                            del mercado digital, desarrollando sistemas web personalizados con enfoque en la experiencia 
                            de usuario y la innovación constante.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Productos Destacados -->
    <section id="products" class="products-section">
        <div class="container">
            <div class="section-title">
                <h2>Productos Destacados</h2>
                <div class="underline"></div>
            </div>

            <div class="row g-4">
                <c:choose>
                    <c:when test="${empty productosDestacados}">
                        <div class="col-12">
                            <div class="alert alert-info text-center">
                                <i class="fas fa-info-circle me-2"></i>
                                No hay productos disponibles en este momento.
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="producto" items="${productosDestacados}">
                            <div class="col-lg-4 col-md-6">
                                <div class="product-card">
                                    <div class="product-image">
                                        <c:choose>
                                            <c:when test="${producto.categoria == 'Servicios'}">
                                                <i class="fas fa-wifi"></i>
                                            </c:when>
                                            <c:when test="${producto.categoria == 'Equipos'}">
                                                <i class="fas fa-router"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fas fa-plug"></i>
                                            </c:otherwise>
                                        </c:choose>
                                        <span class="product-badge">${producto.categoria}</span>
                                    </div>
                                    <div class="product-body">
                                        <div class="product-category">${producto.categoria}</div>
                                        <h3 class="product-title">${producto.nombre}</h3>
                                        <div class="product-price">
                                            S/. <fmt:formatNumber value="${producto.precio}" pattern="#,##0.00"/>
                                        </div>
                                        <c:choose>
                                            <c:when test="${producto.stock > 10}">
                                                <div class="product-stock in-stock">
                                                    <i class="fas fa-check-circle me-1"></i> En Stock (${producto.stock})
                                                </div>
                                            </c:when>
                                            <c:when test="${producto.stock > 0}">
                                                <div class="product-stock low-stock">
                                                    <i class="fas fa-exclamation-circle me-1"></i> Stock Limitado (${producto.stock})
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="product-stock">
                                                    <i class="fas fa-times-circle me-1"></i> Agotado
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        <a href="${pageContext.request.contextPath}/catalogo" class="btn-product">
                                            <i class="fas fa-shopping-cart me-2"></i> Ver Detalles
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="text-center mt-5">
                <a href="${pageContext.request.contextPath}/catalogo" class="btn-hero-primary">
                    <i class="fas fa-th me-2"></i> Ver Todos los Productos
                </a>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="cta-section">
        <div class="container">
            <div class="cta-content">
                <h2>¿Listo para Transformar tu Negocio?</h2>
                <p>Únete a cientos de empresas que confían en nuestras soluciones tecnológicas</p>
                <div class="hero-buttons justify-content-center">
                    <a href="${pageContext.request.contextPath}/catalogo" class="btn-hero-primary">
                        <i class="fas fa-rocket me-2"></i> Comenzar Ahora
                    </a>
                    <a href="#about" class="btn-hero-secondary">
                        <i class="fas fa-phone me-2"></i> Contactar
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h4>NM Telecom</h4>
                    <p>Soluciones tecnológicas inteligentes para tu crecimiento digital.</p>
                    <div class="social-links">
                        <a href="#"><i class="fab fa-facebook-f"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-linkedin-in"></i></a>
                        <a href="#"><i class="fab fa-instagram"></i></a>
                    </div>
                </div>

                <div class="footer-section">
                    <h4>Enlaces Rápidos</h4>
                    <a href="#about">Sobre Nosotros</a>
                    <a href="#products">Productos</a>
                    <a href="${pageContext.request.contextPath}/catalogo">Catálogo</a>
                    <a href="#">Servicios</a>
                </div>

                <div class="footer-section">
                    <h4>Contacto</h4>
                    <p><i class="fas fa-map-marker-alt me-2"></i> Lima, Perú</p>
                    <p><i class="fas fa-phone me-2"></i> +51 999 999 999</p>
                    <p><i class="fas fa-envelope me-2"></i> contacto@nmtelecom.com</p>
                </div>

                <div class="footer-section">
                    <h4>Horario</h4>
                    <p>Lunes - Viernes: 9:00 AM - 6:00 PM</p>
                    <p>Sábado: 9:00 AM - 1:00 PM</p>
                    <p>Domingo: Cerrado</p>
                </div>
            </div>

            <div class="footer-bottom">
                <p>&copy; 2025 NM Telecom. Todos los derechos reservados.</p>
            </div>
        </div>
    </footer>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    // Smooth scroll para enlaces internos
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Auto-play del carrusel con pausa en hover
        const carousel = document.querySelector('#heroCarousel');
        if (carousel) {
            carousel.addEventListener('mouseenter', function() {
                bootstrap.Carousel.getInstance(carousel).pause();
            });
            
            carousel.addEventListener('mouseleave', function() {
                bootstrap.Carousel.getInstance(carousel).cycle();
            });
        }

        // Animación de entrada para elementos al hacer scroll
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver(function(entries) {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.animation = 'fadeInUp 0.8s ease forwards';
                    observer.unobserve(entry.target);
                }
            });
        }, observerOptions);

        // Observar elementos para animación
        document.querySelectorAll('.product-card, .vm-card').forEach(el => {
            el.style.opacity = '0';
            observer.observe(el);
        });

        // Botón para volver arriba
        const scrollToTop = document.createElement('button');
        scrollToTop.innerHTML = '<i class="fas fa-arrow-up"></i>';
        scrollToTop.style.cssText = `
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 50px;
            height: 50px;
            background: var(--nm-accent);
            color: white;
            border: none;
            border-radius: 50%;
            cursor: pointer;
            display: none;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            z-index: 1000;
            box-shadow: 0 4px 12px rgba(56, 167, 152, 0.3);
            transition: all 0.3s ease;
        `;
        
        scrollToTop.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-5px)';
            this.style.boxShadow = '0 6px 20px rgba(56, 167, 152, 0.4)';
        });
        
        scrollToTop.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
            this.style.boxShadow = '0 4px 12px rgba(56, 167, 152, 0.3)';
        });

        scrollToTop.addEventListener('click', function() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });

        document.body.appendChild(scrollToTop);

        // Mostrar/ocultar botón de volver arriba
        window.addEventListener('scroll', function() {
            if (window.pageYOffset > 300) {
                scrollToTop.style.display = 'flex';
            } else {
                scrollToTop.style.display = 'none';
            }
        });

        // Contador animado para estadísticas (si decides agregarlas)
        function animateCounter(element, target, duration = 2000) {
            let start = 0;
            const increment = target / (duration / 16);
            
            const counter = setInterval(() => {
                start += increment;
                if (start >= target) {
                    element.textContent = Math.floor(target);
                    clearInterval(counter);
                } else {
                    element.textContent = Math.floor(start);
                }
            }, 16);
        }

        // Inicializar tooltips de Bootstrap si existen
        const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
    </script>