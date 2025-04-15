package com.wordsearch.api.repository;

import com.wordsearch.api.model.LeaderboardEntry;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;

@Repository
public class LeaderboardRepository {

    @PersistenceContext
    private EntityManager entityManager;

    // Consulta nativa para obtener los top N jugadores con sus puntuaciones máximas
    public List<LeaderboardEntry> findTopPlayers(int limit) {
        String query = """
            SELECT new com.wordsearch.api.model.LeaderboardEntry(u.username, MAX(s.score))
            FROM Score s
            JOIN s.user u
            GROUP BY u.username
            ORDER BY MAX(s.score) DESC
        """;

        return entityManager.createQuery(query, LeaderboardEntry.class)
                            .setMaxResults(limit)
                            .getResultList();
    }
}
