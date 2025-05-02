// lib/services/game_service.dart

class GameService {
  int score = 0;
  List<String> words = ['apple', 'banana', 'grape', 'orange'];
  List<String> foundWords = [];

  // Método para marcar una palabra como encontrada
  void markWordAsFound(String word) {
    if (!foundWords.contains(word)) {
      foundWords.add(word);
      score += 10;  // Incrementar la puntuación
    }
  }

  // Método para reiniciar el juego
  void resetGame() {
    score = 0;
    foundWords.clear();
  }

  // Método para verificar si una palabra está encontrada
  bool isWordFound(String word) {
    return foundWords.contains(word);
  }

  // Método para obtener la lista de palabras encontradas
  List<String> getFoundWords() {
    return foundWords;
  }

  // Método para obtener las palabras por encontrar
  List<String> getRemainingWords() {
    return words.where((word) => !foundWords.contains(word)).toList();
  }
}
