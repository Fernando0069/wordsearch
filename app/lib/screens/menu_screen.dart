import 'package:flutter/material.dart';
import 'game_screen.dart'; // Suponiendo que más adelante crearemos esta pantalla para el juego
import 'scores_screen.dart'; // Y esta para las puntuaciones

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú Principal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => GameScreen()), // Dirige a la pantalla del juego
                );
              },
              child: Text('Empezar Juego'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ScoresScreen()), // Dirige a la pantalla de puntuaciones
                );
              },
              child: Text('Ver Puntuaciones'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Cerrar la aplicación
                Navigator.of(context).pop();
              },
              child: Text('Salir'),
            ),
          ],
        ),
      ),
    );
  }
}
