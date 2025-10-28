package com.utp.nmtelecom.controller;

import com.utp.nmtelecom.dao.UsuarioDAO;
import com.utp.nmtelecom.model.Usuario;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.ui.Model;

import java.sql.SQLException;

// LÍNEAS AÑADIDAS: Importaciones para Logback/SLF4J
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
public class LoginController {

    // LÍNEA AÑADIDA: Declaración del Logger
    private static final Logger logger = LoggerFactory.getLogger(LoginController.class);

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @GetMapping("/login")
    public String mostrarLogin() {
        return "login"; // Muestra login.jsp
    }

    @PostMapping("/login")
    public String procesarLogin(
            @RequestParam("nombreUsuario") String nombreUsuario,
            @RequestParam("password") String password,
            HttpSession session,
            Model model) {

        // LÍNEA AÑADIDA: Log::INFO - Registro del intento de inicio de sesión
        logger.info("Intento de login para el usuario: {}", nombreUsuario);

        try {
            Usuario usuario = usuarioDAO.autenticar(nombreUsuario, password);
            if (usuario != null) {
                session.setAttribute("usuarioLogeado", usuario);
                
                // LÍNEA AÑADIDA: Log::INFO - Acceso Exitoso (RNF-02 OK)
                logger.info("LOGIN EXITOSO: Usuario ID {} ({}) ha iniciado sesión.", 
                             usuario.getIdUsuario(), nombreUsuario);
                
                return "redirect:/catalogo";
            } else {
                // LÍNEA AÑADIDA: Log::WARN - Acceso Fallido
                logger.warn("LOGIN FALLIDO: Credenciales incorrectas para el usuario: {}", nombreUsuario);

                model.addAttribute("mensajeError", "Usuario o contraseña incorrectos.");
                return "login";
            }
        } catch (SQLException e) {
            // LÍNEA AÑADIDA: Log::ERROR - Error Crítico de DB
            logger.error("Error de base de datos durante la autenticación para el usuario {}: {}", 
                         nombreUsuario, e.getMessage(), e);

            e.printStackTrace();
            model.addAttribute("mensajeError", "Error de base de datos durante la autenticación.");
            return "login";
        }
    }
    
}