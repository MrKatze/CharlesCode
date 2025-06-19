class RespuestaActividad {
  final int id;
  final int idActividad;
  final int idAlumno;
  final String respuesta;
  final double? calificacion;
  final String? comentarioMaestro;
  final DateTime fechaRespuesta;
  final String titulo;
  final String descripcion;
  final DateTime? fechaEntrega;

  RespuestaActividad({
    required this.id,
    required this.idActividad,
    required this.idAlumno,
    required this.respuesta,
    this.calificacion,
    this.comentarioMaestro,
    required this.fechaRespuesta,
    required this.titulo,
    required this.descripcion,
    this.fechaEntrega,
  });

  factory RespuestaActividad.fromJson(Map<String, dynamic> json) {
    return RespuestaActividad(
      id: json['id'],
      idActividad: json['id_actividad'],
      idAlumno: json['id_alumno'],
      respuesta: json['respuesta'],
      calificacion: json['calificacion'] != null ? (json['calificacion'] as num).toDouble() : null,
      comentarioMaestro: json['comentario_maestro'],
      fechaRespuesta: DateTime.parse(json['fecha_respuesta']),
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      fechaEntrega: json['fecha_entrega'] != null ? DateTime.parse(json['fecha_entrega']) : null,
    );
  }
}
