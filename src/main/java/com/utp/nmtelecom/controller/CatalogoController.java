package com.utp.nmtelecom.controller;

import com.utp.nmtelecom.dao.ProductoDAO;
import com.utp.nmtelecom.dao.IProductoDAO;
import com.utp.nmtelecom.model.Producto;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@Controller
public class CatalogoController {
    private static final Logger LOGGER = Logger.getLogger(CatalogoController.class.getName());

    private final IProductoDAO productoDAO = new ProductoDAO();

    // 1. Endpoint para /productos (Excluye "Servicios")
    // URL: http://localhost:8087/productos
    @GetMapping("/productos")
    public String mostrarProductos(Model model) {
        try {
            List<Producto> productos = productoDAO.listarActivos();
            model.addAttribute("productos", productos);
            // Bandera para personalización: es un catálogo de productos
            model.addAttribute("esServicio", false); 
            return "jsp/catalogo";

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error DB al cargar productos.", e);
            return "ERROR DE BASE DE DATOS: No se pudo cargar el catálogo de productos. Detalle: " + e.getMessage();
        }
    }

    // 2. Endpoint para /servicio (Solo "Servicios")
    // URL: http://localhost:8087/servicio
    @GetMapping("/servicios") // Corregido de /servicios a /servicio
    public String mostrarServicios(Model model) {
        try {
            List<Producto> servicios = productoDAO.listarServiciosActivos();
            
            model.addAttribute("productos", servicios); 
            
            // Bandera para personalización: es un catálogo de servicios
            model.addAttribute("esServicio", true); 
            
            return "jsp/catalogo";

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error DB al cargar servicios.", e);
            return "ERROR DE BASE DE DATOS: No se pudo cargar el catálogo de servicios. Detalle: " + e.getMessage();
        }
    }
}