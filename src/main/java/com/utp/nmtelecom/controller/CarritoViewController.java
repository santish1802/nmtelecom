package com.utp.nmtelecom.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.ui.Model;
import org.springframework.http.ResponseEntity;
import jakarta.servlet.http.HttpSession;
import com.utp.nmtelecom.model.Usuario;
import com.utp.nmtelecom.util.DatabaseConnection;

import java.sql.*;
import java.util.*;

@Controller
@RequestMapping("/carrito")
public class CarritoViewController {

    @GetMapping
    public String mostrarCarrito(HttpSession session, Model model) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogeado");

        if (usuario == null) {
            return "redirect:/login";
        }

        List<Map<String, Object>> items = new ArrayList<>();
        double total = 0.0;

        String sql = """
            SELECT ic.idItem, p.idProducto, p.nombre, ic.cantidad, ic.precioUnitario,
                   (ic.cantidad * ic.precioUnitario) AS subtotal
            FROM item_carrito ic
            INNER JOIN carrito_compra cc ON ic.carrito_id = cc.idCarrito
            INNER JOIN producto p ON ic.producto_id = p.idProducto
            WHERE cc.usuario_id = ?
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, usuario.getIdUsuario());
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("idItem", rs.getLong("idItem"));
                item.put("idProducto", rs.getLong("idProducto"));
                item.put("nombre", rs.getString("nombre"));
                item.put("cantidad", rs.getInt("cantidad"));
                item.put("precioUnitario", rs.getDouble("precioUnitario"));
                item.put("subtotal", rs.getDouble("subtotal"));
                total += rs.getDouble("subtotal");
                items.add(item);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        model.addAttribute("items", items);
        model.addAttribute("total", total);

        return "carrito";
    }

    @PostMapping
    @ResponseBody
    public ResponseEntity<Map<String, Object>> actualizarCarrito(
            @RequestParam String accion,
            @RequestParam(required = false) Long idItem,
            @RequestParam(required = false) Integer cantidad,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogeado");

        if (usuario == null) {
            response.put("success", false);
            response.put("message", "Sesión expirada");
            return ResponseEntity.ok(response);
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            
            if ("actualizar".equals(accion)) {
                if (cantidad == null || cantidad < 1) {
                    response.put("success", false);
                    response.put("message", "Cantidad inválida");
                    return ResponseEntity.ok(response);
                }

                if (idItem == null) {
                    response.put("success", false);
                    response.put("message", "ID de item inválido");
                    return ResponseEntity.ok(response);
                }

                String sql = """
                    UPDATE item_carrito ic
                    INNER JOIN carrito_compra cc ON ic.carrito_id = cc.idCarrito
                    SET ic.cantidad = ?
                    WHERE ic.idItem = ? AND cc.usuario_id = ?
                """;

                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, cantidad);
                    ps.setLong(2, idItem);
                    ps.setLong(3, usuario.getIdUsuario());
                    
                    int rowsAffected = ps.executeUpdate();
                    
                    if (rowsAffected > 0) {
                        response.put("success", true);
                        response.put("message", "Cantidad actualizada");
                    } else {
                        response.put("success", false);
                        response.put("message", "Producto no encontrado en el carrito");
                    }
                }

            } else if ("eliminar".equals(accion)) {
                if (idItem == null) {
                    response.put("success", false);
                    response.put("message", "ID de item inválido");
                    return ResponseEntity.ok(response);
                }

                String sql = """
                    DELETE ic FROM item_carrito ic
                    INNER JOIN carrito_compra cc ON ic.carrito_id = cc.idCarrito
                    WHERE ic.idItem = ? AND cc.usuario_id = ?
                """;

                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setLong(1, idItem);
                    ps.setLong(2, usuario.getIdUsuario());
                    
                    int rowsAffected = ps.executeUpdate();
                    
                    if (rowsAffected > 0) {
                        response.put("success", true);
                        response.put("message", "Producto eliminado");
                    } else {
                        response.put("success", false);
                        response.put("message", "Producto no encontrado");
                    }
                }

            } else {
                response.put("success", false);
                response.put("message", "Acción no válida");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Error en el servidor: " + e.getMessage());
        }

        return ResponseEntity.ok(response);
    }
}