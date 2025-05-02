import 'package:flutter/material.dart';
import 'game_screen.dart'; // Importa la pantalla del juego
import 'login_screen.dart'; // Importa la pantalla de login

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bienvenido al Juego de Ahorcado')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Título del juego
            Text(
              'Ahorcado',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),

            // Botón para seleccionar el idioma
            ElevatedButton(
              onPressed: () {
                // Lógica para cambiar el idioma
                _selectLanguage(context);
              },
              child: Text('Seleccionar idioma'),
            ),

            SizedBox(height: 20),

            // Botón para iniciar sesión
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de login
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Iniciar sesión'),
            ),

            SizedBox(height: 20),

            // Botón para comenzar el juego
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla del juego
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameScreen()),
                );
              },
              child: Text('Jugar ahora'),
            ),
          ],
        ),
      ),
    );
  }

  // Método para seleccionar idioma (puedes ampliarlo según lo necesites)
  void _selectLanguage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecciona un idioma'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Español'),
                onTap: () {
                  // Cambiar idioma a español
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Inglés'),
                onTap: () {
                  // Cambiar idioma a inglés
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
