package com.wordsearch.api.model;

import jakarta.persistence.*;
import java.util.List;

@Entity
public class WordSearchGame {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String gameName;
    private String language; // Idioma de la partida (e.g. 'en' para inglés, 'es' para español)
    private String status;   // Estado del juego, por ejemplo: 'active', 'completed', etc.
    private int totalScore;

    @ManyToMany
    @JoinTable(
        name = "game_achievements",
        joinColumns = @JoinColumn(name = "game_id"),
        inverseJoinColumns = @JoinColumn(name = "achievement_id")
    )
    private List<Achievement> achievements; // Logros obtenidos en esta partida

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;  // El usuario que juega esta partida

    public WordSearchGame() {
    }

    public WordSearchGame(String gameName, String language, String status, int totalScore, User user) {
        this.gameName = gameName;
        this.language = language;
        this.status = status;
        this.totalScore = totalScore;
        this.user = user;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getGameName() {
        return gameName;
    }

    public void setGameName(String gameName) {
        this.gameName = gameName;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getTotalScore() {
        return totalScore;
    }

    public void setTotalScore(int totalScore) {
        this.totalScore = totalScore;
    }

    public List<Achievement> getAchievements() {
        return achievements;
    }

    public void setAchievements(List<Achievement> achievements) {
        this.achievements = achievements;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}
