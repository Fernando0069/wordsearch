package com.wordsearch.api.controller;

import com.wordsearch.api.model.Game;
import com.wordsearch.api.service.GameService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/games")
public class GameController {

    @Autowired
    private GameService gameService;

    @PostMapping("/start")
    public Game startGame(@RequestBody Game game) {
        return gameService.startGame(game);
    }

    @PostMapping("/end")
    public Game endGame(@RequestBody Game game) {
        return gameService.endGame(game);
    }

    @GetMapping("/{userId}")
    public List<Game> getGamesByUser(@PathVariable Long userId) {
        return gameService.getGamesByUser(userId);
    }
}
