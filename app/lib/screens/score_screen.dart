import 'package:flutter/material.dart';

class ScoresScreen extends StatelessWidget {
  final List<Map<String, dynamic>> scores = [
    {'name': 'Jugador 1', 'score': 120},
    {'name': 'Jugador 2', 'score': 100},
    {'name': 'Jugador 3', 'score': 80},
    {'name': 'Jugador 4', 'score': 60},
    {'name': 'Jugador 5', 'score': 40},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Puntuaciones'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Mejores Puntuaciones',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: scores.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(scores[index]['name']),
                    subtitle: Text('Puntuación: ${scores[index]['score']}'),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Volver al menú
              },
              child: Text('Volver al Menú'),
            ),
          ],
        ),
      ),
    );
  }
}
