import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/usuario.dart';

class AuthService {
  //final String baseUrl =
     // 'http://192.168.1.35:3000/api/usuarios'; // Cambia por tu IP o dominio
  final String baseUrl =
      'http://localhost:3000/api/usuarios'; // Cambia por tu IP o dominio
      
  Future<Usuario?> login(String usuario, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'usuario': usuario, 'password': password}),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return Usuario.fromJson(body['data']);
    } else {
      return null;
    }
  }
}
