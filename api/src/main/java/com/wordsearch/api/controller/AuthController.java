package com.wordsearch.controller;

import com.wordsearch.security.JwtUtil;
import com.wordsearch.security.MyUserDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.*;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth") // Ruta de autenticación
public class AuthController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private MyUserDetailsService userDetailsService;

    @Autowired
    private JwtUtil jwtUtil;

    // Endpoint para login (autenticación)
    @PostMapping("/login")
    public Map<String, Object> login(@RequestBody AuthRequest authRequest) {
        try {
            // Autenticación del usuario usando las credenciales
            Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(authRequest.getUsername(), authRequest.getPassword())
            );

            // Obtener el usuario autenticado
            UserDetails userDetails = userDetailsService.loadUserByUsername(authRequest.getUsername());
            
            // Generar el token JWT
            String token = jwtUtil.generateToken(userDetails.getUsername());

            // Respuesta con el token
            Map<String, Object> response = new HashMap<>();
            response.put("token", token);
            return response;

        } catch (BadCredentialsException e) {
            // Si las credenciales son incorrectas, retornamos un error
            Map<String, Object> response = new HashMap<>();
            response.put("error", "Invalid username or password");
            return response;
        }
    }

    // Endpoint para registro de nuevo usuario
    @PostMapping("/register")
    public Map<String, Object> register(@RequestBody AuthRequest authRequest) {
        // Aquí se debe agregar la lógica para registrar al usuario en la base de datos.
        // Para este ejemplo, solo se simula el registro.

        // Crear un nuevo usuario en la base de datos (esto es un ejemplo, deberías agregar lógica de almacenamiento)
        // userDetailsService.registerNewUser(authRequest.getUsername(), authRequest.getPassword());

        // Suponiendo que el registro fue exitoso, generamos el token
        UserDetails userDetails = userDetailsService.loadUserByUsername(authRequest.getUsername());
        String token = jwtUtil.generateToken(userDetails.getUsername());

        // Respuesta con el token generado
        Map<String, Object> response = new HashMap<>();
        response.put("token", token);
        return response;
    }

    // DTO para recibir username y password en el login o registro
    public static class AuthRequest {
        private String username;
        private String password;

        public String getUsername() {
            return username;
        }
        
        public void setUsername(String username) {
            this.username = username;
        }

        public String getPassword() {
            return password;
        }

        public void setPassword(String password) {
            this.password = password;
        }
    }
}
