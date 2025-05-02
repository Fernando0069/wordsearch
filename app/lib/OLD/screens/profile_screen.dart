sdsdsd
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User Profile'),
            SizedBox(height: 20),
            Text('Puntuaciones: 1000'), // Aquí puedes mostrar las puntuaciones reales.
          ],
        ),
      ),
    );
  }
}
