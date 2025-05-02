import 'package:postgres/postgres.dart';

class DBHelper {
  final PostgreSQLConnection connection;

  DBHelper()
      : connection = PostgreSQLConnection(
          'your_host', // Reemplaza con tu host de PostgreSQL
          5432,        // Puerto de PostgreSQL, normalmente es 5432
          'your_database_name', // Nombre de la base de datos
          username: 'your_username', // Tu usuario de PostgreSQL
          password: 'your_password', // Tu contraseña de PostgreSQL
        );

  Future<void> connect() async {
    await connection.open();
  }

  Future<void> close() async {
    await connection.close();
  }

  // Guardar puntuación en la base de datos
  Future<void> saveScore(String playerName, int score) async {
    await connection.query(
      'INSERT INTO scores (name, score) VALUES (@name, @score)',
      substitutionValues: {'name': playerName, 'score': score},
    );
  }

  // Obtener las mejores puntuaciones
  Future<List<Map<String, dynamic>>> getTopScores() async {
    final results = await connection.query('SELECT name, score FROM scores ORDER BY score DESC LIMIT 10');
    return results.map((row) => {'name': row[0], 'score': row[1]}).toList();
  }
}
