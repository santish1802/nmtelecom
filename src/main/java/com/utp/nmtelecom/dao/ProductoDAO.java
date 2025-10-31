package com.utp.nmtelecom.dao;

import com.utp.nmtelecom.model.Producto;
import com.utp.nmtelecom.util.DatabaseConnection;
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
    
    // Consulta genérica para listar productos/servicios activos (se añade condición de categoría)
    private static final String SQL_LISTAR_ACTIVOS_BASE = 
            "SELECT p.idProducto, p.codigo, p.nombre, p.precio, p.categoria, i.stockActual AS stock, p.activo FROM producto p LEFT JOIN inventario i ON p.idProducto = i.producto_id WHERE p.activo = TRUE";
    
    private static final String SQL_OBTENER_POR_ID = 
            "SELECT p.idProducto, p.codigo, p.nombre, p.descripcion, p.precio, p.categoria, i.stockActual AS stock, p.activo FROM producto p LEFT JOIN inventario i ON p.idProducto = i.producto_id WHERE p.idProducto = ?";

    // NUEVO: Método privado para manejar la lógica de listado con el filtro de servicio
    private List<Producto> listarActivos(boolean esServicio) throws SQLException {
        List<Producto> productos = new ArrayList<>();
        String sql = SQL_LISTAR_ACTIVOS_BASE;
        
        // Si es servicio, busca categoria = 'Servicios'. Si no, busca categoria != 'Servicios'.
        if (esServicio) {
            sql += " AND p.categoria = 'Servicios'";
        } else {
            sql += " AND p.categoria != 'Servicios'";
        }
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Producto p = new Producto();
                p.setIdProducto(rs.getLong("idProducto"));
                p.setCodigo(rs.getString("codigo"));
                p.setNombre(rs.getString("nombre"));
                p.setPrecio(rs.getBigDecimal("precio"));
                p.setCategoria(rs.getString("categoria"));
                // El campo stock puede no ser relevante para servicios, pero se mantiene para la clase Producto
                p.setStock(rs.getInt("stock")); 
                p.setActivo(rs.getBoolean("activo"));
                productos.add(p);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al listar productos/servicios activos (esServicio=" + esServicio + ").", e);
            throw e;
        }
        return productos;
    }

    // Implementación original para productos (NO servicios)
    @Override
    public List<Producto> listarActivos() throws SQLException {
        // Llama al método privado indicando que NO es servicio.
        return listarActivos(false); 
    }
    
    @Override
    public List<Producto> listarServiciosActivos() throws SQLException {
        // Llama al método privado indicando que SÍ es servicio.
        return listarActivos(true); 
    }
    
    @Override
    public Producto obtenerPorId(Long id) throws SQLException {
        // Mantiene la implementación original sin cambios
        Producto producto = null;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_OBTENER_POR_ID)) {
            // ... (código para obtener por ID sin cambios)
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    producto = new Producto();
                    producto.setIdProducto(rs.getLong("idProducto"));
                    producto.setCodigo(rs.getString("codigo"));
                    producto.setNombre(rs.getString("nombre"));
                    producto.setDescripcion(rs.getString("descripcion"));
                    producto.setPrecio(rs.getBigDecimal("precio"));
                    producto.setCategoria(rs.getString("categoria"));
                    producto.setStock(rs.getInt("stock"));
                    producto.setActivo(rs.getBoolean("activo"));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al obtener producto por ID.", e);
            throw e;
        }
        return producto;
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