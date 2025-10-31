package com.utp.nmtelecom.controller;

import com.utp.nmtelecom.model.Producto;
import com.utp.nmtelecom.util.DatabaseConnection; // Asumimos esta utilidad de conexión
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.ServletContext;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@Controller
// Mapeo base para /admin/productos
@RequestMapping("/admin/productos") 
public class AdminProductoController {
    
    private static final Logger LOGGER = Logger.getLogger(AdminProductoController.class.getName());
    private final ServletContext servletContext; 

    // Consultas SQL (Constantes de acceso directo a la DB)
    private static final String SQL_LISTAR_TODOS = 
            "SELECT p.idProducto, p.codigo, p.nombre, p.descripcion, p.precio, p.categoria, i.stockActual AS stock, p.activo FROM producto p LEFT JOIN inventario i ON p.idProducto = i.producto_id ORDER BY p.idProducto DESC";
    private static final String SQL_OBTENER_POR_ID = 
            "SELECT p.idProducto, p.codigo, p.nombre, p.descripcion, p.precio, p.categoria, i.stockActual AS stock, p.activo FROM producto p LEFT JOIN inventario i ON p.idProducto = i.producto_id WHERE p.idProducto = ?";
    private static final String SQL_AGREGAR = 
            "INSERT INTO producto (codigo, nombre, descripcion, precio, categoria, activo) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String SQL_ACTUALIZAR = 
            "UPDATE producto SET codigo = ?, nombre = ?, descripcion = ?, precio = ?, categoria = ?, activo = ? WHERE idProducto = ?";
    private static final String SQL_ACTUALIZAR_INVENTARIO = 
            "INSERT INTO inventario (producto_id, stockActual, stockMinimo, ultimaActualizacion) VALUES (?, ?, 0, NOW()) ON DUPLICATE KEY UPDATE stockActual = ?";
    private static final String SQL_ELIMINAR = // Desactivar (activo=FALSE)
            "UPDATE producto SET activo = FALSE WHERE idProducto = ?";
    
    // Constructor para inyectar el ServletContext (Necesario para la ruta de la imagen)
    public AdminProductoController(ServletContext servletContext) {
        this.servletContext = servletContext;
    }
    
    // UTILITY: Mapea el ResultSet a un objeto Producto (Reemplaza la función DAO)
    private Producto mapearProducto(ResultSet rs) throws SQLException {
        Producto p = new Producto();
        p.setIdProducto(rs.getLong("idProducto"));
        p.setCodigo(rs.getString("codigo"));
        p.setNombre(rs.getString("nombre"));
        p.setDescripcion(rs.getString("descripcion")); 
        p.setPrecio(rs.getBigDecimal("precio"));
        p.setCategoria(rs.getString("categoria"));
        p.setStock(rs.getInt("stock"));
        p.setActivo(rs.getBoolean("activo"));
        return p;
    }

    // ===============================================
    // C - READ: /admin/productos (Listar todos)
    // ===============================================
    @GetMapping
    public String listarProductos(Model model) {
        List<Producto> productos = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_LISTAR_TODOS);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                productos.add(mapearProducto(rs));
            }
            model.addAttribute("productos", productos);
            return "jsp/admin/listado"; // Vista de listado
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al listar productos para el administrador. JDBC directo.", e);
            model.addAttribute("error", "Error al cargar la lista: " + e.getMessage());
            return "jsp/error";
        }
    }

    // ===============================================
    // C - READ: /admin/productos/nuevo o /editar/{id} (Mostrar Formulario)
    // ===============================================
    @GetMapping({"/nuevo", "/editar/{id}"})
    public String mostrarFormulario(@PathVariable(required = false) Long id, Model model) {
        Producto producto = new Producto();
        String titulo = "Crear Nuevo Ítem";

        if (id != null) {
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(SQL_OBTENER_POR_ID)) {
                
                ps.setLong(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        producto = mapearProducto(rs);
                        titulo = "Editar Ítem: " + producto.getNombre();
                    } else {
                        return "redirect:/admin/productos"; // No encontrado
                    }
                }
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error al obtener producto por ID: " + id, e);
                return "redirect:/admin/productos";
            }
        }
        
        model.addAttribute("categorias", List.of("Equipos", "Hardware", "Accesorio", "Servicios", "Plan"));
        model.addAttribute("producto", producto);
        model.addAttribute("titulo", titulo);
        
        return "jsp/admin/formulario"; // Vista del formulario
    }

    // ===============================================
    // C - CREATE/UPDATE: /admin/productos/guardar (Guardar Lógica POST)
    // ===============================================
    @PostMapping("/guardar")
    public String guardarProducto(
        @ModelAttribute Producto producto,
        @RequestParam("imagenFile") MultipartFile imagenFile, 
        RedirectAttributes redirectAttributes) {

        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false); // Iniciar transacción

            // 1. Manejo de la Imagen
            if (!imagenFile.isEmpty()) {
                String uploadDir = servletContext.getRealPath("/images/");
                String originalFilename = imagenFile.getOriginalFilename();
                String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
                String fileName = producto.getCodigo() + extension;
                Path filePath = Paths.get(uploadDir, fileName);

                Files.createDirectories(filePath.getParent()); 
                Files.write(filePath, imagenFile.getBytes());
            }

            // 2. Operación JDBC (INSERT o UPDATE)
            if (producto.getIdProducto() == null) {
                // INSERT (Agregar)
                try (PreparedStatement ps = conn.prepareStatement(SQL_AGREGAR, PreparedStatement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, producto.getCodigo());
                    ps.setString(2, producto.getNombre());
                    ps.setString(3, producto.getDescripcion());
                    ps.setBigDecimal(4, producto.getPrecio());
                    ps.setString(5, producto.getCategoria());
                    ps.setBoolean(6, producto.getActivo());
                    ps.executeUpdate();
                    
                    // Obtener ID generado para inventario
                    try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            producto.setIdProducto(generatedKeys.getLong(1));
                        }
                    }
                }
                redirectAttributes.addFlashAttribute("mensaje", "Ítem '" + producto.getNombre() + "' creado exitosamente.");
            } else {
                // UPDATE (Actualizar)
                try (PreparedStatement ps = conn.prepareStatement(SQL_ACTUALIZAR)) {
                    ps.setString(1, producto.getCodigo());
                    ps.setString(2, producto.getNombre());
                    ps.setString(3, producto.getDescripcion());
                    ps.setBigDecimal(4, producto.getPrecio());
                    ps.setString(5, producto.getCategoria());
                    ps.setBoolean(6, producto.getActivo());
                    ps.setLong(7, producto.getIdProducto());
                    ps.executeUpdate();
                }
                redirectAttributes.addFlashAttribute("mensaje", "Ítem '" + producto.getNombre() + "' actualizado exitosamente.");
            }
            
            // 3. Actualizar Inventario (Solo si es Hardware/Accesorio)
            if (("Equipos".equals(producto.getCategoria()) || "Hardware".equals(producto.getCategoria()) || "Accesorio".equals(producto.getCategoria())) && producto.getIdProducto() != null) {
                try (PreparedStatement psInventario = conn.prepareStatement(SQL_ACTUALIZAR_INVENTARIO)) {
                    psInventario.setLong(1, producto.getIdProducto());
                    psInventario.setInt(2, producto.getStock() != null ? producto.getStock() : 0);
                    psInventario.setInt(3, producto.getStock() != null ? producto.getStock() : 0);
                    psInventario.executeUpdate();
                }
            }

            conn.commit(); // Confirmar transacción

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error de DB al guardar/actualizar ítem. JDBC directo.", e);
            if (conn != null) { try { conn.rollback(); } catch (SQLException rollbackEx) {} }
            redirectAttributes.addFlashAttribute("error", "Error de base de datos: " + e.getMessage());
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error al subir la imagen del ítem.", e);
            redirectAttributes.addFlashAttribute("error", "Error al guardar la imagen: " + e.getMessage());
        } finally {
            if (conn != null) { try { conn.close(); } catch (SQLException closeEx) {} }
        }

        return "redirect:/admin/productos";
    }
    
    // ===============================================
    // D - DELETE: /admin/productos/eliminar/{id} (Desactivar)
    // ===============================================
    @GetMapping("/eliminar/{id}")
    public String eliminarProducto(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_ELIMINAR)) {
            
            ps.setLong(1, id);
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                redirectAttributes.addFlashAttribute("mensaje", "Ítem ID " + id + " ha sido desactivado exitosamente (activo=0).");
            } else {
                redirectAttributes.addFlashAttribute("error", "No se encontró el ítem ID " + id + " para desactivar.");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al desactivar ítem ID: " + id + ". JDBC directo.", e);
            redirectAttributes.addFlashAttribute("error", "Error al intentar desactivar el ítem: " + e.getMessage());
        }
        return "redirect:/admin/productos";
    }
}