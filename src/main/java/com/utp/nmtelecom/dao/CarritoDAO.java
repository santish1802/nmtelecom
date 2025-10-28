package com.utp.nmtelecom.dao;

import com.utp.nmtelecom.model.ItemCarrito; // Necesitas este modelo para manejar el item
import com.utp.nmtelecom.model.Producto; // Necesitas este modelo para el precio
import com.utp.nmtelecom.util.DatabaseConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * DAO ÚNICO para la gestión del carrito (cabecera y detalle).
 */
public class CarritoDAO {

    // --- Métodos Auxiliares Internos ---

    private Producto obtenerProductoPorId(Long idProducto) throws SQLException {
        // Asumimos que ProductoDAO existe o replicamos la lógica mínima para obtener solo el precio.
        String sql = "SELECT precio FROM producto WHERE idProducto = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, idProducto);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Producto p = new Producto();
                    p.setPrecio(rs.getBigDecimal("precio"));
                    return p;
                }
            }
            return null;
        }
    }

    private Long obtenerOCrearCarritoId(Long usuarioId) throws SQLException {
        String sqlSelect = "SELECT idCarrito FROM carrito_compra WHERE usuario_id = ?";
        String sqlInsert = "INSERT INTO carrito_compra (usuario_id, fechaCreacion, total) VALUES (?, CURDATE(), 0.00)";
        Long carritoId = null;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement psSelect = conn.prepareStatement(sqlSelect)) {
            psSelect.setLong(1, usuarioId);
            try (ResultSet rs = psSelect.executeQuery()) {
                if (rs.next()) {
                    carritoId = rs.getLong("idCarrito");
                }
            }
        }

        if (carritoId == null) {
            // Si no existe, crearlo
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement psInsert = conn.prepareStatement(sqlInsert, Statement.RETURN_GENERATED_KEYS)) {
                psInsert.setLong(1, usuarioId);
                psInsert.executeUpdate();
                try (ResultSet rs = psInsert.getGeneratedKeys()) {
                    if (rs.next()) {
                        carritoId = rs.getLong(1);
                    }
                }
            }
        }
        return carritoId;
    }

    private ItemCarrito buscarItemPorProducto(Long carritoId, Long productoId) throws SQLException {
        String sql = "SELECT idItem, cantidad, precioUnitario FROM item_carrito WHERE carrito_id = ? AND producto_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, carritoId);
            ps.setLong(2, productoId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ItemCarrito item = new ItemCarrito();
                    item.setIdItem(rs.getLong("idItem"));
                    item.setCantidad(rs.getInt("cantidad"));
                    item.setPrecioUnitario(rs.getBigDecimal("precioUnitario"));
                    return item;
                }
            }
            return null;
        }
    }
    
    private void actualizarTotales(Long carritoId) throws SQLException {
        // Calcula la suma de subtotales y actualiza el campo 'total' en carrito_compra
        String sqlUpdate = "UPDATE carrito_compra SET total = (SELECT COALESCE(SUM(subtotal), 0) FROM item_carrito WHERE carrito_id = ?) WHERE idCarrito = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
            ps.setLong(1, carritoId);
            ps.setLong(2, carritoId);
            ps.executeUpdate();
        }
    }
    
    // --- Lógica Principal ---

    /**
     * Agrega un producto al carrito del usuario, actualizando la BD.
     * @return El número total de items (líneas distintas) en el carrito para el badge.
     */
    public int agregarProducto(Long usuarioId, Long idProducto, int cantidad) throws SQLException {
        
        Producto producto = obtenerProductoPorId(idProducto);
        if (producto == null) {
            throw new SQLException("El producto no existe o no tiene precio definido.");
        }
        
        Long carritoId = obtenerOCrearCarritoId(usuarioId);
        ItemCarrito itemExistente = buscarItemPorProducto(carritoId, idProducto);
        BigDecimal precioUnitario = producto.getPrecio();
        
        // Calcular nuevos valores
        int nuevaCantidad;
        Long idItem;
        
        if (itemExistente != null) {
            // Caso 1: Actualizar ítem existente
            idItem = itemExistente.getIdItem();
            nuevaCantidad = itemExistente.getCantidad() + cantidad;
            
            String sql = "UPDATE item_carrito SET cantidad = ?, subtotal = ? WHERE idItem = ?";
            BigDecimal nuevoSubtotal = precioUnitario.multiply(new BigDecimal(nuevaCantidad));
            
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, nuevaCantidad);
                ps.setBigDecimal(2, nuevoSubtotal);
                ps.setLong(3, idItem);
                ps.executeUpdate();
            }
        } else {
            // Caso 2: Insertar nuevo ítem
            nuevaCantidad = cantidad;
            String sql = "INSERT INTO item_carrito (carrito_id, producto_id, cantidad, precioUnitario, subtotal) VALUES (?, ?, ?, ?, ?)";
            BigDecimal subtotal = precioUnitario.multiply(new BigDecimal(nuevaCantidad));
            
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, carritoId);
                ps.setLong(2, idProducto);
                ps.setInt(3, nuevaCantidad);
                ps.setBigDecimal(4, precioUnitario);
                ps.setBigDecimal(5, subtotal);
                ps.executeUpdate();
            }
        }
        
        // Final: Recalcular totales y contar
        actualizarTotales(carritoId);
        
        // Devuelve el conteo de líneas de item para el badge
        return contarItemsDistintos(carritoId);
    }
    
    // Cuenta cuántos items distintos hay en el carrito (para el badge)
    public int contarItemsDistintos(Long carritoId) throws SQLException {
        String sql = "SELECT COUNT(idItem) FROM item_carrito WHERE carrito_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, carritoId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            return 0;
        }
    }
}