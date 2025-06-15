class Usuario {
  final int idUsuario;
  final String nombre;
  final String usuario;
  final String correo;
  final String password;
  final String rol;

  Usuario({
    required this.idUsuario,
    required this.nombre,
    required this.usuario,
    required this.correo,
    required this.password,
    required this.rol,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idUsuario: json['id_usuario'],
      nombre: json['nombre'],
      usuario: json['usuario'],
      correo: json['correo'],
      password: json['password'],
      rol: json['rol'],
    );
  }
}