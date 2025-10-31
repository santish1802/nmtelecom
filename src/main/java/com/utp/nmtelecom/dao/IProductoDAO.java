package com.utp.nmtelecom.dao;

import com.utp.nmtelecom.model.Producto;
import java.util.List;
import java.sql.SQLException;

/**
 * Interfaz que define las operaciones de acceso a datos para la entidad Producto.
 * Permite que la implementación cambie (JDBC, JPA).
 */
public interface IProductoDAO {
    // Métodos esenciales para el catálogo
    List<Producto> listarActivos() throws SQLException;
    Producto obtenerPorId(Long id) throws SQLException;
    
    List<Producto> listarServiciosActivos() throws SQLException;
    
    // Métodos para la gestión (CRUD, requerimiento RF-01)
    void agregar(Producto producto) throws SQLException;
    void actualizar(Producto producto) throws SQLException;
    void eliminar(Long id) throws SQLException;
}