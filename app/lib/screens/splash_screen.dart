import 'package:flutter/material.dart';
import '../utils/language_helper.dart'; // Utilidades de idioma (aún lo crearemos más tarde)

class SplashScreen extends StatelessWidget {
  final AppLanguage language;
  final Function(AppLanguage) onLanguageChanged;

  SplashScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Diccionario de strings según el idioma
    final strings = {
      AppLanguage.english: {
        'title': 'Hangman',
        'start': 'Start Game',
        'language': 'Language',
      },
      AppLanguage.spanish: {
        'title': 'Ahorcado',
        'start': 'Empezar Juego',
        'language': 'Idioma',
      },
    };

    final text = strings[language]!;

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text['title']!,
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            DropdownButton<AppLanguage>(
              value: language,
              onChanged: (lang) {
                if (lang != null) onLanguageChanged(lang);
              },
              items: [
                DropdownMenuItem(
                  value: AppLanguage.english,
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: AppLanguage.spanish,
                  child: Text('Español'),
                ),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PlaceholderScreen()),
                );
              },
              child: Text(text['start']!),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Aquí irá el juego 🎯', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
