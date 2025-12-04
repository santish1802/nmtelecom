package com.utp.nmtelecom.dao;

import com.utp.nmtelecom.model.Usuario;
import com.utp.nmtelecom.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * DAO para la gestión de la tabla 'usuario'
 * Utiliza la clase DatabaseConnection para obtener las conexiones a la BD.
 */
public class UsuarioDAO {

    /**
     * * @param usuario El objeto Usuario a registrar.
     * @return El ID generado del nuevo usuario o null si falló el registro (ej: duplicado).
     * @throws SQLException 
     */
    public Long registrarUsuario(Usuario usuario) throws SQLException {
        // 1. Verificar si el usuario ya existe (nombre o email)
        if (existeUsuario(usuario.getNombreUsuario(), usuario.getEmail())) {
            return null; // El usuario ya existe, no se registra
        }
        
        String sql = "INSERT INTO usuario (nombreUsuario, email, password_hash, rol, fechaCreacion) VALUES (?, ?, ?, ?, CURDATE())";
        Long idGenerado = null;
        
        // El try-with-resources garantiza el cierre de la Connection (conn) y el PreparedStatement (ps)
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, usuario.getNombreUsuario());
            ps.setString(2, usuario.getEmail());
            // ADVERTENCIA: Usar un hash fuerte (BCrypt) en la vida real.
            ps.setString(3, usuario.getPasswordHash()); 
            ps.setString(4, usuario.getRol());

            int filasAfectadas = ps.executeUpdate();
            
            if (filasAfectadas > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        idGenerado = rs.getLong(1);
                        usuario.setIdUsuario(idGenerado);
                    }
                }
            }
            return idGenerado;
        }
    }
    
    /**
     * Verifica si ya existe un usuario con el mismo nombre de usuario o email.
     */
    public boolean existeUsuario(String nombreUsuario, String email) throws SQLException {
        // Consulta para verificar duplicados
        String sql = "SELECT COUNT(*) FROM usuario WHERE nombreUsuario = ? OR email = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, nombreUsuario);
            ps.setString(2, email);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Si el conteo es mayor a 0, significa que el usuario ya existe
                    return rs.getInt(1) > 0; 
                }
            }
            return false;
        }
    }
    
    /**
     * Intenta autenticar a un usuario con nombre de usuario y contraseña (hash simple).
     * @return Objeto Usuario si las credenciales son correctas, o null si fallan.
     * @throws SQLException 
     */
    public Usuario autenticar(String nombreUsuario, String password) throws SQLException {
        String sql = "SELECT idUsuario, nombreUsuario, email, rol FROM usuario WHERE nombreUsuario = ? AND password_hash = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, nombreUsuario);
            ps.setString(2, password); // ADVERTENCIA: Comparar hashes en producción (no texto plano)

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Usuario u = new Usuario();
                    u.setIdUsuario(rs.getLong("idUsuario"));
                    u.setNombreUsuario(rs.getString("nombreUsuario"));
                    u.setEmail(rs.getString("email"));
                    u.setRol(rs.getString("rol"));
                    // No se recupera el hash por seguridad
                    return u;
                }
            }
            return null; // Usuario no encontrado o credenciales incorrectas
        }
    }
}