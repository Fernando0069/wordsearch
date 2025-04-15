package com.wordsearch.api.service;

import com.wordsearch.api.model.User;
import com.wordsearch.api.model.WordSearchGame;
import com.wordsearch.api.repository.WordSearchRepository;
import com.wordsearch.api.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class LeaderboardService {

    @Autowired
    private WordSearchRepository wordSearchRepository;

    @Autowired
    private UserRepository userRepository;

    /**
     * Obtiene el ranking de puntuaciones de todos los jugadores, ordenado por puntuación.
     * @return Una lista de usuarios ordenados por puntuación total.
     */
    public List<User> getLeaderboard() {
        List<WordSearchGame> games = wordSearchRepository.findAll();
        
        return games.stream()
                .collect(Collectors.groupingBy(game -> game.getUser().getId(), Collectors.summingInt(WordSearchGame::getTotalScore)))
                .entrySet().stream()
                .map(entry -> {
                    User user = userRepository.findById(entry.getKey()).orElseThrow(() -> new RuntimeException("User not found"));
                    user.setTotalScore(entry.getValue());
                    return user;
                })
                .sorted((u1, u2) -> Integer.compare(u2.getTotalScore(), u1.getTotalScore())) // Ordenar por puntuación de mayor a menor
                .collect(Collectors.toList());
    }

    /**
     * Obtiene las partidas activas de un jugador específico.
     * @param userId El ID del usuario.
     * @return Lista de partidas activas del usuario.
     */
    public List<WordSearchGame> getActiveGamesByUser(Long userId) {
        return wordSearchRepository.findByUserIdAndStatus(userId, "active");
    }

    /**
     * Obtiene el total de partidas completadas de un jugador específico.
     * @param userId El ID del usuario.
     * @return Número total de partidas completadas.
     */
    public long getCompletedGamesCount(Long userId) {
        return wordSearchRepository.findByUserIdAndStatus(userId, "completed").size();
    }

    /**
     * Obtiene la puntuación total de un jugador específico.
     * @param userId El ID del usuario.
     * @return Puntuación total del jugador.
     */
    public int getTotalScoreByUser(Long userId) {
        List<WordSearchGame> games = wordSearchRepository.findByUserId(userId);
        return games.stream().mapToInt(WordSearchGame::getTotalScore).sum();
    }
}
