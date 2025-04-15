import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/game_screen.dart';
import 'screens/profile_screen.dart';
import 'app_routes.dart';

void main() {
  runApp(WordSearchApp());
}

class WordSearchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRoutes.welcome,
      routes: {
        AppRoutes.welcome: (context) => WelcomeScreen(),
        AppRoutes.game: (context) => GameScreen(),
        AppRoutes.profile: (context) => ProfileScreen(),
      },
    );
  }
}
