class RespuestaActividad {
  final int idActividad;
  final int idAlumno;
  final int? id;
  final String respuesta;
  double? calificacion;
  String? comentarioMaestro;
  final DateTime? fechaRespuesta;
  final String titulo;
  final String descripcion;
  final DateTime? fechaEntrega;
  final String? nombreEstudiante;

  RespuestaActividad({
    required this.idActividad,
    required this.idAlumno,
    this.id,
    required this.respuesta,
    this.calificacion,
    this.comentarioMaestro,
    this.fechaRespuesta,
    required this.titulo,
    required this.descripcion,
    this.fechaEntrega,
    this.nombreEstudiante,
  });

  factory RespuestaActividad.fromJson(Map<String, dynamic> json) {
    return RespuestaActividad(
      idActividad:
          json['id_actividad'] != null
              ? int.tryParse(json['id_actividad'].toString()) ?? 0
              : 0,
      idAlumno:
          json['id_alumno'] != null
              ? int.tryParse(json['id_alumno'].toString()) ?? 0
              : 0,
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      respuesta: json['respuesta'] ?? '',
      calificacion:
          json['calificacion'] != null
              ? double.tryParse(json['calificacion'].toString())
              : null,
      comentarioMaestro: json['comentario_maestro'],
      fechaRespuesta:
          (json['fecha_respuesta'] != null && json['fecha_respuesta'] != '')
              ? DateTime.tryParse(json['fecha_respuesta'].toString())
              : null,
      titulo: json['titulo'] ?? '',
      descripcion: json['descripcion'] ?? '',
      fechaEntrega:
          (json['fecha_entrega'] != null && json['fecha_entrega'] != '')
              ? DateTime.tryParse(json['fecha_entrega'].toString())
              : null,
      nombreEstudiante: json['nombre_estudiante'],
    );
  }
}
