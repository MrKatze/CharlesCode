// Servicio para registro de usuario
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/usuario.dart';

class UsuarioServices {
  static const String _baseUrl =
      'http://localhost:3000/usuarios'; // Ajusta la URL según tu backend

  static Future<bool> registrarUsuario(Usuario usuario) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/agregar'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': usuario.nombre,
        'usuario': usuario.usuario,
        'correo': usuario.correo,
        'password': usuario.password,
        'rol': usuario.rol,
      }),
    );
    return response.statusCode == 201;
  }
}
