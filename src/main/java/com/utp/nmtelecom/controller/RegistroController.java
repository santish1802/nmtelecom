package com.utp.nmtelecom.controller;

import com.utp.nmtelecom.dao.UsuarioDAO;
import com.utp.nmtelecom.model.Usuario;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;

@Controller
@RequestMapping("/registro")
public class RegistroController {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @GetMapping
    public String mostrarFormulario() {
        return "registro";
    }

    @PostMapping
    public String registrarUsuario(
            @RequestParam String nombreUsuario,
            @RequestParam String email,
            @RequestParam String password,
            HttpSession session,
            Model model) {

        if (nombreUsuario.isEmpty() || email.isEmpty() || password.isEmpty()) {
            model.addAttribute("mensaje", "Todos los campos son obligatorios.");
            return "registro";
        }

        try {
            Usuario nuevoUsuario = new Usuario(nombreUsuario, email, password, "CLIENTE");
            Long idGenerado = usuarioDAO.registrarUsuario(nuevoUsuario);

            if (idGenerado != null) {
                session.setAttribute("usuarioLogeado", nuevoUsuario);
                return "redirect:/catalogo";
            } else {
                model.addAttribute("mensaje", "Error al registrar el usuario. El nombre o email ya existen.");
                return "registro";
            }
        } catch (SQLException e) {
            model.addAttribute("mensaje", "Error de base de datos: " + e.getMessage());
            return "registro";
        }
    }
}
