class LenguajeTemario {
  final String descripcion;
  final List<String> temario;

  LenguajeTemario({
    required this.descripcion,
    required this.temario,
  });

  factory LenguajeTemario.fromJson(Map<String, dynamic> json) {
    List<dynamic> temasJson = json['temario'] ?? [];
    List<String> temas = temasJson.map((e) => e.toString()).toList();

    return LenguajeTemario(
      descripcion: json['descripcion'] ?? '',
      temario: temas,
    );
  }
}
