package com.utp.nmtelecom.controller;

import com.utp.nmtelecom.dao.ProductoDAO;
import com.utp.nmtelecom.dao.IProductoDAO;
import com.utp.nmtelecom.model.Producto;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@Controller
public class DetalleController {
    private static final Logger LOGGER = Logger.getLogger(DetalleController.class.getName());

    // Se instancia el DAO, siguiendo el patrón de CatalogoController
    private final IProductoDAO productoDAO = new ProductoDAO(); 

    /**
     * Muestra el detalle de un producto o servicio a partir de su ID.
     * Mapea ambas URLs: /producto/detalle/{id} y /servicio/detalle/{id}.
     */
    @GetMapping({"/producto/detalle/{id}", "/servicio/detalle/{id}"})
    public String mostrarDetalle(@PathVariable("id") Long id, Model model) {
        try {
            // Usa el método existente en IProductoDAO
            Producto producto = productoDAO.obtenerPorId(id);

            if (producto == null) {
                // Manejo de ID no encontrado
                model.addAttribute("errorMessage", "El ítem con ID " + id + " no fue encontrado en el catálogo.");
                return "jsp/error"; // Debes crear una vista de error simple
            }

            model.addAttribute("producto", producto);
            
            // Bandera útil para la vista JSP (para cambiar textos/botones)
            model.addAttribute("esServicio", "Servicios".equals(producto.getCategoria()));

            // La vista JSP se llamará 'detalle.jsp'
            return "jsp/detalle"; 
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error DB al cargar el detalle del ID: " + id, e);
            model.addAttribute("errorMessage", "Error al consultar la base de datos para el detalle: " + e.getMessage());
            return "jsp/error";
        }
    }
}