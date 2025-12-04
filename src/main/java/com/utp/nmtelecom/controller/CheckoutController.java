package com.utp.nmtelecom.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.ui.Model;
import jakarta.servlet.http.HttpSession;
import com.utp.nmtelecom.model.Usuario;
import com.utp.nmtelecom.util.DatabaseConnection;

import java.sql.*;
import java.time.LocalDate;

@Controller
@RequestMapping("/checkout")
public class CheckoutController {

    @GetMapping
    public String procesarCompra(HttpSession session, Model model) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogeado");

        if (usuario == null) {
            return "redirect:/login";
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);

            try {
                // 1. Obtener el carrito del usuario
                Long idCarrito = null;
                String sqlCarrito = "SELECT idCarrito FROM carrito_compra WHERE usuario_id = ?";
                
                try (PreparedStatement ps = conn.prepareStatement(sqlCarrito)) {
                    ps.setLong(1, usuario.getIdUsuario());
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        idCarrito = rs.getLong("idCarrito");
                    }
                }

                if (idCarrito == null) {
                    model.addAttribute("error", "No se encontró un carrito activo");
                    return "redirect:/carrito";
                }

                // 2. Calcular el total del carrito
                double total = 0.0;
                String sqlTotal = """
                    SELECT SUM(cantidad * precioUnitario) as total
                    FROM item_carrito
                    WHERE carrito_id = ?
                """;
                
                try (PreparedStatement ps = conn.prepareStatement(sqlTotal)) {
                    ps.setLong(1, idCarrito);
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        total = rs.getDouble("total");
                    }
                }

                if (total <= 0) {
                    return "redirect:/carrito";
                }

                // 3. Generar número de orden único
                String numeroOrden = generarNumeroOrden(conn);

                // 4. Crear la orden de compra como COMPLETADA
                String sqlOrden = """
                    INSERT INTO orden_compra (numeroOrden, usuario_id, fechaOrden, estado, total)
                    VALUES (?, ?, ?, 'COMPLETADA', ?)
                """;
                
                Long idOrden = null;
                try (PreparedStatement ps = conn.prepareStatement(sqlOrden, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, numeroOrden);
                    ps.setLong(2, usuario.getIdUsuario());
                    ps.setDate(3, java.sql.Date.valueOf(LocalDate.now()));
                    ps.setDouble(4, total);
                    ps.executeUpdate();
                    
                    ResultSet rs = ps.getGeneratedKeys();
                    if (rs.next()) {
                        idOrden = rs.getLong(1);
                    }
                }

                // 5. Copiar items del carrito a la orden
                String sqlCopiarItems = """
                    INSERT INTO item_orden (orden_id, producto_id, cantidad, precioUnitario)
                    SELECT ?, producto_id, cantidad, precioUnitario
                    FROM item_carrito
                    WHERE carrito_id = ?
                """;
                
                try (PreparedStatement ps = conn.prepareStatement(sqlCopiarItems)) {
                    ps.setLong(1, idOrden);
                    ps.setLong(2, idCarrito);
                    ps.executeUpdate();
                }

                // 6. Vaciar el carrito
                String sqlVaciarCarrito = "DELETE FROM item_carrito WHERE carrito_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sqlVaciarCarrito)) {
                    ps.setLong(1, idCarrito);
                    ps.executeUpdate();
                }

                // 7. Commit de la transacción
                conn.commit();

                // Guardar datos para la página de confirmación
                model.addAttribute("numeroOrden", numeroOrden);
                model.addAttribute("fechaOrden", LocalDate.now());
                model.addAttribute("total", total);
                model.addAttribute("estado", "COMPLETADA");

                return "confirmacion";

            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                model.addAttribute("error", "Error al procesar la compra: " + e.getMessage());
                return "redirect:/carrito";
            }

        } catch (SQLException e) {
            e.printStackTrace();
            model.addAttribute("error", "Error de conexión: " + e.getMessage());
            return "redirect:/carrito";
        }
    }

    // Método auxiliar para generar número de orden único
    private String generarNumeroOrden(Connection conn) throws SQLException {
        String sql = "SELECT MAX(CAST(SUBSTRING(numeroOrden, 5) AS UNSIGNED)) as maxNum FROM orden_compra WHERE numeroOrden LIKE 'ORD-%'";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int maxNum = rs.getInt("maxNum");
                return String.format("ORD-%04d", maxNum + 1);
            }
        }
        
        return "ORD-0001";
    }
}