// lib/screens/game_screen.dart

import 'package:flutter/material.dart';
import 'package:word_search/services/game_service.dart';  // Importamos el servicio

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameService _gameService = GameService();  // Instancia del servicio

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Search Game'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _gameService.resetGame();  // Reiniciar el juego al presionar el botón
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Score: ${_gameService.score}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Find the words:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Column(
              children: _gameService.words.map((word) {
                bool isFound = _gameService.isWordFound(word);
                return Text(
                  word,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isFound ? Colors.green : Colors.black, // Color verde si la palabra fue encontrada
                  ),
                );
              }).toList(),
            ),
            Expanded(
              child: Center(
                child: Container(
                  height: 300,
                  width: 300,
                  color: Colors.grey[200],
                  child: Center(
                    child: Text(
                      'Word Search Grid',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _gameService.markWordAsFound('apple'); // Ejemplo de palabra encontrada
                });
              },
              child: Text('Found a word!'),
            ),
          ],
        ),
      ),
    );
  }
}
