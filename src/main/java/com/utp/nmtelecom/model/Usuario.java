package com.utp.nmtelecom.model;

import java.io.Serializable;
import java.sql.Date;

/**
 * Clase de modelo que representa la tabla 'usuario'
 */
public class Usuario implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long idUsuario;
    private String nombreUsuario;
    private String email;
    private String passwordHash;
    private String rol; // Valores posibles: 'CLIENTE', 'VENDEDOR', 'ADMIN'
    private Date fechaCreacion;

    // Constructor vacío (necesario)
    public Usuario() {}

    // Constructor para registro simplificado
    public Usuario(String nombreUsuario, String email, String passwordHash, String rol) {
        this.nombreUsuario = nombreUsuario;
        this.email = email;
        this.passwordHash = passwordHash;
        this.rol = rol;
        // La fechaCreacion se manejará en el DAO o en la BD
    }

    // Getters y Setters
    public Long getIdUsuario() { return idUsuario; }
    public void setIdUsuario(Long idUsuario) { this.idUsuario = idUsuario; }

    public String getNombreUsuario() { return nombreUsuario; }
    public void setNombreUsuario(String nombreUsuario) { this.nombreUsuario = nombreUsuario; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getRol() { return rol; }
    public void setRol(String rol) { this.rol = rol; }

    public Date getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(Date fechaCreacion) { this.fechaCreacion = fechaCreacion; }
}