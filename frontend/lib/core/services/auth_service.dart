import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/models/usuario.dart';

class AuthService {
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

  Future<List<Usuario>> obtenerEstudiantes() async {
    final response = await http.get(Uri.parse('$baseUrl/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List usuarios = data['data'];

      return usuarios
          .map((json) => Usuario.fromJson(json))
          .toList()
          .where((u) => u.rol == 'Estudiante') // por si acaso
          .toList();
    } else {
      throw Exception('Error al obtener estudiantes');
    }
  }
}
