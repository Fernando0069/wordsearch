package com.wordsearch.api.security;

import com.wordsearch.api.util.JwtUtil;
import com.wordsearch.api.service.MyUserDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Component
public class JwtRequestFilter extends OncePerRequestFilter {

    @Autowired
    private JwtUtil jwtUtil; // Util para gestionar el JWT

    @Autowired
    private MyUserDetailsService userDetailsService; // Debes crear esta clase para cargar los detalles del usuario

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {

        final String authHeader = request.getHeader("Authorization");

        String username = null;
        String jwtToken = null;

        // Verifica si el token empieza con "Bearer "
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            jwtToken = authHeader.substring(7); // Extrae el token del encabezado
            username = jwtUtil.extractUsername(jwtToken); // Extrae el nombre de usuario desde el token
        }

        // Si el token es válido y el usuario no está autenticado, lo autenticamos
        if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
            UserDetails userDetails = userDetailsService.loadUserByUsername(username); // Carga los detalles del usuario

            // Verifica si el token es válido para el usuario
            if (jwtUtil.validateToken(jwtToken, userDetails.getUsername())) {
                // Crea un token de autenticación y lo establece en el contexto de seguridad
                UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                        userDetails, null, userDetails.getAuthorities()
                );
                authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request)); // Añade detalles adicionales
                SecurityContextHolder.getContext().setAuthentication(authToken); // Establece el token de autenticación
            }
        }

        // Continua con el siguiente filtro en la cadena
        chain.doFilter(request, response);
    }
}
