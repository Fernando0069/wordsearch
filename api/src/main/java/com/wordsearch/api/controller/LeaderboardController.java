package com.wordsearch.api.controller;

import com.wordsearch.api.model.LeaderboardEntry;
import com.wordsearch.api.repository.LeaderboardRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/leaderboard")
public class LeaderboardController {

    @Autowired
    private LeaderboardRepository leaderboardRepository;

    // Obtener los mejores jugadores (top 10)
    @GetMapping("/top")
    public List<LeaderboardEntry> getTopPlayers(@RequestParam(defaultValue = "10") int limit) {
        return leaderboardRepository.findTopPlayers(limit);
    }
}
