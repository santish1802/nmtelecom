package com.utp.nmtelecom.model;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * Representa un item o línea dentro del Carrito de Compras.
 * Relaciona un Producto con una Cantidad dentro de un Carrito.
 */
public class ItemCarrito implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long idItem;
    // Aunque el idCarrito se puede usar aquí, lo simplificamos para la sesión:
    // private Long carritoId; 
    
    private Producto producto; // Objeto Producto asociado (Relación de Agregación/Composición)
    private Integer cantidad;
    private BigDecimal precioUnitario;
    private BigDecimal subtotal; // PrecioUnitario * Cantidad

    // Constructor vacío (necesario)
    public ItemCarrito() {
        this.cantidad = 0;
        this.precioUnitario = BigDecimal.ZERO;
        this.subtotal = BigDecimal.ZERO;
    }

    // Constructor útil para inicializar
    public ItemCarrito(Producto producto, Integer cantidad) {
        this.producto = producto;
        this.cantidad = cantidad;
        this.precioUnitario = producto.getPrecio();
        calcularSubtotal();
    }
    
    /**
     * Lógica de negocio: Calcula el subtotal del item.
     */
    public void calcularSubtotal() {
        if (this.precioUnitario != null && this.cantidad != null) {
            this.subtotal = this.precioUnitario.multiply(new BigDecimal(this.cantidad));
        } else {
            this.subtotal = BigDecimal.ZERO;
        }
    }
    
    // Getters y Setters
    public Long getIdItem() {
        return idItem;
    }

    public void setIdItem(Long idItem) {
        this.idItem = idItem;
    }

    public Producto getProducto() {
        return producto;
    }

    public void setProducto(Producto producto) {
        this.producto = producto;
        if (producto != null) {
            this.precioUnitario = producto.getPrecio();
            calcularSubtotal();
        }
    }

    public Integer getCantidad() {
        return cantidad;
    }

    public void setCantidad(Integer cantidad) {
        this.cantidad = cantidad;
        calcularSubtotal(); // Recalcular el subtotal al cambiar la cantidad
    }

    public BigDecimal getPrecioUnitario() {
        return precioUnitario;
    }

    public void setPrecioUnitario(BigDecimal precioUnitario) {
        this.precioUnitario = precioUnitario;
        calcularSubtotal();
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }
    
    // El subtotal no tiene setter, ya que se calcula automáticamente (buena práctica).
}