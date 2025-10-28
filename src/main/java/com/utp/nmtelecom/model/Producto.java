package com.utp.nmtelecom.model;

import java.math.BigDecimal;
import java.io.Serializable;

/**
 * Clase POJO (Plain Old Java Object) que representa la entidad Producto.
 * (Cumple con el Principio de Responsabilidad Única - SOLID S)
 */
public class Producto implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long idProducto;
    private String codigo;
    private String nombre;
    private BigDecimal precio;
    private String categoria;
    private Integer stock;
    private Boolean activo;
    
    // Constructor vacío (necesario para frameworks)
    public Producto() {}

    // Constructor completo
    public Producto(Long idProducto, String codigo, String nombre, BigDecimal precio, String categoria, Integer stock, Boolean activo) {
        this.idProducto = idProducto;
        this.codigo = codigo;
        this.nombre = nombre;
        this.precio = precio;
        this.categoria = categoria;
        this.stock = stock;
        this.activo = activo;
    }

    // Getters y Setters
    public Long getIdProducto() { return idProducto; }
    public void setIdProducto(Long idProducto) { this.idProducto = idProducto; }

    public String getCodigo() { return codigo; }
    public void setCodigo(String codigo) { this.codigo = codigo; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public BigDecimal getPrecio() { return precio; }
    public void setPrecio(BigDecimal precio) { this.precio = precio; }

    public String getCategoria() { return categoria; }
    public void setCategoria(String categoria) { this.categoria = categoria; }

    public Integer getStock() { return stock; }
    public void setStock(Integer stock) { this.stock = stock; }

    public Boolean getActivo() { return activo; }
    public void setActivo(Boolean activo) { this.activo = activo; }
    
    /**
     * Lógica simple de negocio (cumple TDD: primero se prueba, luego se implementa)
     * @return true si el stock es mayor a 0
     */
    public boolean validarStock() {
        return this.stock != null && this.stock > 0;
    }
}