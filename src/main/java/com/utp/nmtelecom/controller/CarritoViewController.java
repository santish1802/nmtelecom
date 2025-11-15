package com.utp.nmtelecom.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import jakarta.servlet.http.HttpSession;
import org.springframework.ui.Model;
import com.utp.nmtelecom.model.Usuario;
import java.sql.*;
import java.util.*;

import com.utp.nmtelecom.util.DatabaseConnection;

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
            SELECT p.nombre, ic.cantidad, ic.precioUnitario,
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

        return "carrito"; // buscará /webapp/carrito.jsp
    }
}
