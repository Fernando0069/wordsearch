package com.wordsearch.service;

import com.wordsearch.model.Game;
import com.wordsearch.repository.GameRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GameService {

    @Autowired
    private GameRepository gameRepository;

    public Game startGame(Game game) {
        return gameRepository.save(game);
    }

    public Game endGame(Game game) {
        return gameRepository.save(game);
    }

    public List<Game> getGamesByUser(Long userId) {
        return gameRepository.findByUserId(userId);
    }
}
