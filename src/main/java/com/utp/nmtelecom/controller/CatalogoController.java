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

    // Inyección manual simple (puedes usar @Autowired más adelante)
    private final IProductoDAO productoDAO = new ProductoDAO();

    @GetMapping("/catalogo")
    public String mostrarCatalogo(Model model) {
        try {
            // 1. Lógica de negocio (Modelo)
            List<Producto> productos = productoDAO.listarActivos();

            // 2. Pasar datos a la vista
            model.addAttribute("productos", productos);

            // 3. Mostrar vista JSP
            return "jsp/catalogo"; // -> src/main/webapp/jsp/catalogo.jsp

        } catch (SQLException e) {
            // 1. Logear el error
            LOGGER.log(Level.SEVERE, "Error en la conexión o consulta a la base de datos.", e);

            // 2. Devolver el error como texto plano (o HTML simple)
            // La URL sigue siendo /catalogo, pero el contenido es solo el error.
            return "ERROR DE BASE DE DATOS: No se pudo cargar el catálogo. Detalle: " + e.getMessage();
        }
    }
}
