package com.wordsearch.util;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import java.util.Date;
import org.springframework.beans.factory.annotation.Value;

public class JwtUtil {
    @Value("${jwt.secret}")
    private String secretKey;

    // Método para generar el token
    public String generateToken(String username) {
        return Jwts.builder()
                .setSubject(username)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 10))  // 10 horas de expiración
                .signWith(SignatureAlgorithm.HS256, secretKey)
                .compact();
    }

    // Método para extraer el username del token
    public String extractUsername(String token) {
        return extractClaims(token).getSubject();
    }

    // Método para extraer los Claims (información del token)
    private Claims extractClaims(String token) {
        try {
            return Jwts.parser()
                       .setSigningKey(secretKey)
                       .parseClaimsJws(token)
                       .getBody();
        } catch (Exception e) {
            throw new RuntimeException("Token inválido o malformado", e);  // Lanzar excepción si el token es inválido
        }
    }
    
    // Método para verificar si el token ha expirado
    private boolean isTokenExpired(String token) {
        return extractClaims(token).getExpiration().before(new Date());
    }

    // Método para validar el token
    public boolean validateToken(String token, String username) {
        return (username.equals(extractUsername(token)) && !isTokenExpired(token));
    }
}
