import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/temario.dart'; // Ajusta ruta según tu proyecto

class LenguajeService {
  // final String baseUrl = 'http://192.168.1.76:3000/api/temas'; // Cambia por tu URL
  final String baseUrl =
      'http://192.168.1.102/api/usuarios'; // Cambia por tu IP o dominio

  Future<LenguajeTemario?> obtenerLenguajeTemario(String nombre) async {
    final url = Uri.parse('$baseUrl/$nombre');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return LenguajeTemario.fromJson(body);
      } else {
        // Opcional: puedes manejar errores según statusCode
        return null;
      }
    } catch (e) {
      print('Error en obtenerLenguajeTemario: $e');
      return null;
    }
  }
}
