import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/actividad.dart';
import '../../models/respuestas.dart';

class ActividadService {
  static const String _baseUrl = 'http://localhost:3000/api/actividades';

  static Future<bool> registrarActividad(Actividad actividad) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/agregar'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(actividad.toJson()),
    );
    return response.statusCode == 201;
  }

  static Future<List<Actividad>> obtenerActividadesPorMaestro(
    int idMaestro,
  ) async {
    final response = await http.get(Uri.parse('$_baseUrl/maestro/$idMaestro'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List actividadesJson = data['data'];
      return actividadesJson.map((json) => Actividad.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar actividades');
    }
  }

  static Future<List<RespuestaActividad>> obtenerRespuestasPorAlumno(
    int idAlumno,
  ) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/respuestas/alumno/$idAlumno'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List respuestasJson = data['data'];
      return respuestasJson
          .map((json) => RespuestaActividad.fromJson(json))
          .toList();
    } else {
      throw Exception('Error al cargar respuestas del alumno');
    }
  }
}
