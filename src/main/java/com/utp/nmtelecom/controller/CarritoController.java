package com.utp.nmtelecom.controller;

import com.utp.nmtelecom.model.Usuario;
import com.utp.nmtelecom.util.DatabaseConnection;

import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;
import java.sql.*;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

// LÍNEAS AÑADIDAS: Importaciones para Logback/SLF4J
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@RestController
@RequestMapping("/carrito")
public class CarritoController {

    // LÍNEA AÑADIDA: Declaración del Logger
    private static final Logger logger = LoggerFactory.getLogger(CarritoController.class);


    /**
     * Maneja POST: Agregar producto al carrito (AJAX)
     */
    @PostMapping
    public Map<String, Object> agregarProducto(
            @RequestParam String accion,
            @RequestParam(required = false) String idProducto,
            HttpSession session) {

        Map<String, Object> jsonResponse = new HashMap<>();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogeado");

        // Verificar autenticación
        if (usuario == null) {
            // Log::WARN - Intento de operación sin sesión
            logger.warn("Intento de agregar producto sin sesión de usuario.");
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Debe iniciar sesión para agregar productos al carrito.");
            jsonResponse.put("requireLogin", true);
            return jsonResponse;
        }

        if (!"agregar".equals(accion) || idProducto == null || idProducto.isEmpty()) {
            // Log::WARN - Parámetros inválidos
            logger.warn("Usuario ID {} envió parámetros inválidos para agregar producto.", usuario.getIdUsuario());
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Parámetros inválidos.");
            return jsonResponse;
        }

        try {
            long idProd = Long.parseLong(idProducto);
            long usuarioId = usuario.getIdUsuario();
            
            // Log::INFO - Inicio de operación
            logger.info("Usuario ID {} intenta agregar Producto ID {} al carrito.", usuarioId, idProd);

            boolean agregado = agregarAlCarrito(usuarioId, idProd);

            if (agregado) {
                int count = contarItemsCarrito(usuarioId);
                session.setAttribute("carritoCount", count);
                
                // Log::INFO - Operación exitosa
                logger.info("Producto ID {} agregado con éxito al carrito del Usuario ID {}.", idProd, usuarioId);

                jsonResponse.put("success", true);
                jsonResponse.put("message", "Producto agregado al carrito.");
                jsonResponse.put("count", count);
            } else {
                // Log::WARN - Fallo de lógica (stock, validación)
                logger.warn("Fallo en la lógica 'agregarAlCarrito' para Producto ID {} y Usuario ID {}.", idProd, usuarioId);
                jsonResponse.put("success", false);
                jsonResponse.put("message", "No se pudo agregar el producto al carrito.");
            }

        } catch (NumberFormatException e) {
            // Log::ERROR - Error de formato (Dato incorrecto)
            logger.error("Error al parsear ID de producto '{}' para Usuario ID {}.", idProducto, usuario.getIdUsuario(), e);
            jsonResponse.put("success", false);
            jsonResponse.put("message", "ID de producto inválido.");
        } catch (SQLException e) {
            // Log::ERROR - Error crítico de Base de Datos
            logger.error("Error crítico de base de datos al agregar producto al carrito para Usuario ID {}: {}", 
                         usuario.getIdUsuario(), e.getMessage(), e); // 'e' incluye la traza completa (stack trace)
            e.printStackTrace();
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Error de base de datos.");
        }

        return jsonResponse;
    }

    /**
     * Obtiene o crea un carrito para el usuario
     */
    private Long obtenerOCrearCarrito(long usuarioId) throws SQLException {
        String sqlSelect = "SELECT idCarrito FROM carrito_compra WHERE usuario_id = ?";
        String sqlInsert = "INSERT INTO carrito_compra (usuario_id, fechaCreacion, total) VALUES (?, ?, 0.00)";

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Buscar carrito existente
            try (PreparedStatement ps = conn.prepareStatement(sqlSelect)) {
                ps.setLong(1, usuarioId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    return rs.getLong("idCarrito");
                }
            }

            // Crear nuevo carrito
            try (PreparedStatement ps = conn.prepareStatement(sqlInsert, Statement.RETURN_GENERATED_KEYS)) {
                ps.setLong(1, usuarioId);
                ps.setDate(2, Date.valueOf(LocalDate.now()));
                ps.executeUpdate();

                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    // Log::INFO - Creación exitosa de un nuevo carrito
                    logger.info("Nuevo carrito ID {} creado para Usuario ID {}.", rs.getLong(1), usuarioId);
                    return rs.getLong(1);
                }
            }
        }
        return null;
    }

    /**
     * Agrega un producto al carrito o incrementa la cantidad si ya existe
     */
    private boolean agregarAlCarrito(long usuarioId, long idProducto) throws SQLException {
        String sqlProducto = "SELECT p.precio, i.stockActual AS stock FROM producto p JOIN inventario i ON p.idProducto = i.producto_id WHERE p.idProducto = ? AND p.activo = 1";
        double precio = 0;
        int stock = 0;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlProducto)) {
            ps.setLong(1, idProducto);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                return false;
            }

            precio = rs.getDouble("precio");
            stock = rs.getInt("stock");

            if (stock <= 0) {
                // Log::WARN - Producto sin stock
                logger.warn("Producto ID {} sin stock (0). Operación cancelada. Usuario ID: {}", idProducto, usuarioId);
                return false;
            }
        }

        Long carritoId = obtenerOCrearCarrito(usuarioId);
        if (carritoId == null) {
            return false;
        }

        String sqlCheck = "SELECT idItem, cantidad FROM item_carrito WHERE carrito_id = ? AND producto_id = ?";
        String sqlUpdate = "UPDATE item_carrito SET cantidad = cantidad + 1 WHERE idItem = ?";
        String sqlInsert = "INSERT INTO item_carrito (carrito_id, producto_id, cantidad, precioUnitario) VALUES (?, ?, 1, ?)";

        try (Connection conn = DatabaseConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(sqlCheck)) {
                ps.setLong(1, carritoId);
                ps.setLong(2, idProducto);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    long idItem = rs.getLong("idItem");
                    int cantidadActual = rs.getInt("cantidad");

                    if (cantidadActual + 1 > stock) {
                        // Log::WARN - Límite de stock excedido
                        logger.warn("Usuario ID {} no puede agregar más del Producto ID {}. Límite de stock excedido. Stock: {}, Solicitado: {}.", 
                                     usuarioId, idProducto, stock, cantidadActual + 1);
                        return false;
                    }

                    try (PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate)) {
                        psUpdate.setLong(1, idItem);
                        return psUpdate.executeUpdate() > 0;
                    }
                } else {
                    try (PreparedStatement psInsert = conn.prepareStatement(sqlInsert)) {
                        psInsert.setLong(1, carritoId);
                        psInsert.setLong(2, idProducto);
                        psInsert.setDouble(3, precio);
                        return psInsert.executeUpdate() > 0;
                    }
                }
            }
        }
    }

    /**
     * Cuenta el número de items diferentes en el carrito
     */
    private int contarItemsCarrito(long usuarioId) throws SQLException {
        // CAMBIO: Usamos SUM(ic.cantidad) en lugar de COUNT(*)
        String sql = "SELECT SUM(ic.cantidad) as total FROM item_carrito ic " +
                "INNER JOIN carrito_compra cc ON ic.carrito_id = cc.idCarrito " +
                "WHERE cc.usuario_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, usuarioId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                // Nota: SUM() puede devolver NULL si no hay ítems. En Java, se traduce a 0.
                return rs.getInt("total"); 
            }
        }
        return 0;
    }
}