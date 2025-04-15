package com.wordsearch.api.util;

public class ValidationUtils {

    // Verifica si una cadena es nula o está vacía
    public static boolean isNullOrEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    // Valida si un nombre de usuario cumple con un mínimo de caracteres
    public static boolean isValidUsername(String username) {
        return !isNullOrEmpty(username) && username.length() >= 3;
    }

    // Valida si un idioma es uno de los permitidos (en, es)
    public static boolean isValidLanguage(String language) {
        return "en".equalsIgnoreCase(language) || "es".equalsIgnoreCase(language);
    }

    // Valida si una puntuación está en un rango lógico
    public static boolean isValidScore(int score) {
        return score >= 0 && score <= 1000000; // ajustable según reglas del juego
    }
}
