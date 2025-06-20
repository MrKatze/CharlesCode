import 'dart:convert';
import 'package:http/http.dart' as http;

class EstadisticasServices {
  static const String _baseUrl = 'http://192.168.1.102:3000/api/estadisticas';

  static Future<List<dynamic>> obtenerPromedioAlumnos() async {
    final response = await http.get(Uri.parse('$_baseUrl/promedio-alumnos'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Error al obtener promedios');
    }
  }

  static Future<List<dynamic>> obtenerHistograma() async {
    final response = await http.get(Uri.parse('$_baseUrl/histograma'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Error al obtener histograma');
    }
  }

  static Future<List<dynamic>> obtenerProgreso() async {
    final response = await http.get(Uri.parse('$_baseUrl/progreso'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Error al obtener progreso');
    }
  }

  static Future<List<dynamic>> obtenerComparativa() async {
    final response = await http.get(Uri.parse('$_baseUrl/comparativa'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Error al obtener comparativa');
    }
  }
}
