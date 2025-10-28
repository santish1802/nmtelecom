package com.utp.nmtelecom.dao;

import com.utp.nmtelecom.model.Producto;
import com.utp.nmtelecom.util.DatabaseConnection; // Tu clase de conexión
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Implementación del DAO de Producto usando JDBC estándar.
 */
public class ProductoDAO implements IProductoDAO {
    
    private static final Logger LOGGER = Logger.getLogger(ProductoDAO.class.getName());
    
    private static final String SQL_LISTAR_ACTIVOS = 
            "SELECT idProducto, codigo, nombre, precio, categoria, stock, activo FROM producto WHERE activo = TRUE";
    
    private static final String SQL_OBTENER_POR_ID = 
            "SELECT idProducto, codigo, nombre, precio, categoria, stock, activo FROM producto WHERE idProducto = ?";

    @Override
    public List<Producto> listarActivos() throws SQLException {
        List<Producto> productos = new ArrayList<>();
        // Uso de try-with-resources para manejo automático de la conexión.
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_LISTAR_ACTIVOS);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Producto p = new Producto();
                p.setIdProducto(rs.getLong("idProducto"));
                p.setCodigo(rs.getString("codigo"));
                p.setNombre(rs.getString("nombre"));
                p.setPrecio(rs.getBigDecimal("precio"));
                p.setCategoria(rs.getString("categoria"));
                p.setStock(rs.getInt("stock"));
                p.setActivo(rs.getBoolean("activo"));
                productos.add(p);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al listar productos activos.", e);
            throw e; // Relanza la excepción para que el Controller la maneje
        }
        return productos;
    }

    @Override
    public Producto obtenerPorId(Long id) throws SQLException {
        // Implementación simplificada (solo se necesita el método 'listarActivos' para el catálogo inicial)
        // ... (Implementación completa con PreparedStatement para obtener un producto específico)
        return null;
    }

    // Los métodos 'agregar', 'actualizar', 'eliminar' se implementan al hacer el módulo CRUD
    @Override
    public void agregar(Producto producto) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void actualizar(Producto producto) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void eliminar(Long id) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }
}