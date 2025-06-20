import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/actividad.dart';
import '../../models/respuestas.dart';

class ActividadService {
  static const String _baseUrl = 'http://192.168.1.102:3000/api/actividades';
  // Cambia por tu IP o dominio

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
      Uri.parse('$_baseUrl/respuestas/$idAlumno'),
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

  static Future<List<RespuestaActividad>> obtenerRespuestasPorActividad(
    int idActividad,
  ) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/respuestas/actividad/$idActividad'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List respuestasJson = data['data'];
      return respuestasJson
          .map((json) => RespuestaActividad.fromJson(json))
          .toList();
    } else {
      throw Exception('Error al cargar respuestas de la actividad');
    }
  }

  static Future<List<RespuestaActividad>> obtenerActividadesConEstado(
    int idAlumno,
  ) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/respuestas/$idAlumno'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List respuestasJson = data['data'];
      return respuestasJson
          .map((json) => RespuestaActividad.fromJson(json))
          .toList();
    } else {
      throw Exception('Error al cargar actividades del alumno');
    }
  }

  static Future<bool> enviarRespuesta(
    int idActividad,
    int idEstudiante,
    String respuesta,
  ) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/respuestas/enviar'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_actividad': idActividad,
        'id_alumno': idEstudiante,
        'respuesta': respuesta,
      }),
    );
    debugPrint('Status code: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
    // Acepta tanto 200 (update) como 201 (insert) como éxito
    return response.statusCode == 200 || response.statusCode == 201;
  }

  static Future<bool> actualizarCalificacionRespuesta({
    required int idRespuesta,
    required double calificacion,
    required String comentarioMaestro,
  }) async {
    final url = Uri.parse('$_baseUrl/respuestas/$idRespuesta/calificar');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'calificacion': calificacion,
        'comentario_maestro': comentarioMaestro,
      }),
    );

    return response.statusCode == 200;
  }

  static Future<bool> modificarActividad(Actividad actividad) async {
    final url = Uri.parse('$_baseUrl/${actividad.id}');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(actividad.toJson()),
    );

    return response.statusCode == 200;
  }
}
