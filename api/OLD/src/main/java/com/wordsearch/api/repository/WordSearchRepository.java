package com.wordsearch.api.repository;

import com.wordsearch.api.model.WordSearchGame;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface WordSearchRepository extends JpaRepository<WordSearchGame, Long> {

    // Buscar por nombre de la partida
    Optional<WordSearchGame> findByGameName(String gameName);

    // Buscar todas las partidas de un usuario
    List<WordSearchGame> findByUserId(Long userId);

    // Buscar las partidas activas
    List<WordSearchGame> findByStatus(String status);

    // Buscar partidas por usuario y estado
    List<WordSearchGame> findByUserIdAndStatus(Long userId, String status);
}
