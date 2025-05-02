import 'package:flutter/material.dart';
import 'db_helper.dart'; // Asegúrate de importar el helper de la base de datos
import 'package:tu_proyecto/utils/db_helper.dart';


class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String _wordToGuess = 'FLUTTER';
  List<String> _guessedLetters = [];
  int _attemptsLeft = 6;
  bool _gameOver = false;
  bool _won = false;

  // Instanciamos el helper para interactuar con la base de datos
  final DBHelper _dbHelper = DBHelper();

  // Comprobar si la letra es correcta
  void _guessLetter(String letter) {
    if (_guessedLetters.contains(letter) || _gameOver) return;

    setState(() {
      _guessedLetters.add(letter);
      if (!_wordToGuess.contains(letter)) {
        _attemptsLeft--;
      }

      if (_attemptsLeft == 0) {
        _gameOver = true;
        _won = false;
      }

      if (_wordToGuess.split('').every((letter) => _guessedLetters.contains(letter))) {
        _gameOver = true;
        _won = true;
      }
    });
  }

  // Guardar la puntuación al finalizar el juego
  void _saveScore() async {
    // Suponemos que el nombre del jugador es 'Jugador1'
    String playerName = 'Jugador1';
    await _dbHelper.saveScore(playerName, _attemptsLeft);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Juego de Ahorcado')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Palabra a adivinar:',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              _buildWord(),
              style: TextStyle(fontSize: 36, letterSpacing: 4),
            ),
            SizedBox(height: 20),
            Text(
              'Intentos restantes: $_attemptsLeft',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            _gameOver
                ? Column(
                    children: [
                      Text(
                        _won ? '¡Ganaste!' : '¡Perdiste! La palabra era $_wordToGuess',
                        style: TextStyle(fontSize: 24, color: _won ? Colors.green : Colors.red),
                      ),
                      ElevatedButton(
                        onPressed: _saveScore, // Guardar la puntuación al finalizar
                        child: Text('Guardar Puntuación'),
                      ),
                    ],
                  )
                : Wrap(
                    spacing: 10,
                    children: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').map((letter) {
                      return ElevatedButton(
                        onPressed: () => _guessLetter(letter),
                        child: Text(letter),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }

  String _buildWord() {
    return _wordToGuess
        .split('')
        .map((letter) => _guessedLetters.contains(letter) ? letter : '_')
        .join(' ');
  }
}
