import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'utils/language_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Idioma por defecto es inglés
  AppLanguage _language = AppLanguage.english;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hangman Game',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
        language: _language,
        onLanguageChanged: (lang) {
          setState(() {
            _language = lang;
          });
        },
      ),
    );
  }
}
