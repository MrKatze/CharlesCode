class Actividad {
  final int? id;
  final String titulo;
  final String descripcion;
  final String? fechaEntrega;
  final int idMaestro;
  final int idLenguaje;

  Actividad({
    this.id,
    required this.titulo,
    required this.descripcion,
    this.fechaEntrega,
    required this.idMaestro,
    required this.idLenguaje,
  });

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'fecha_entrega': fechaEntrega,
      'id_maestro': idMaestro,
      'id_lenguaje': idLenguaje,
    };
  }

  factory Actividad.fromJson(Map<String, dynamic> json) {
    return Actividad(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      fechaEntrega: json['fecha_entrega'],
      idMaestro: json['id_maestro'],
      idLenguaje: json['id_lenguaje'],
    );
  }
}
