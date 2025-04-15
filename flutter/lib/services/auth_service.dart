import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final String apiUrl = 'http://localhost:8080/api/auth';

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Suponemos que la API devuelve un token JWT
      String token = json.decode(response.body)['token'];
      // Guardar el token para el uso posterior
      return true;
    } else {
      return false;
    }
  }
}
