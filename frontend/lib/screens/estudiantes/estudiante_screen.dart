import 'package:flutter/material.dart';
import '../../../models/usuario.dart';

class ScreenStudents extends StatelessWidget {
  final Usuario maestro;

  const ScreenStudents({super.key, required this.maestro});

  @override
  Widget build(BuildContext context) {
    // Este será un ejemplo estático. Luego puedes reemplazarlo por datos reales.
    final estudiantes = [
  Usuario(
    idUsuario: 1,
    nombre: 'Juan Pérez',
    usuario: 'juan.perez',
    correo: 'juan@example.com',
    password: '123456',
    rol: 'Estudiante',
  ),
  Usuario(
    idUsuario: 2,
    nombre: 'Ana Gómez',
    usuario: 'ana.gomez',
    correo: 'ana@example.com',
    password: '123456',
    rol: 'Estudiante',
  ),
];

    return Scaffold(
      appBar: AppBar(
        title: Text('Alumnos de ${maestro.nombre}'),
      ),
      body: ListView.builder(
        itemCount: estudiantes.length,
        itemBuilder: (context, index) {
          final estudiante = estudiantes[index];
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(estudiante.nombre),
            subtitle: const Text('Progreso: 70%'), // Aquí pondrás progreso real luego
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Aquí puedes navegar a un detalle individual del estudiante si lo deseas
              // Navigator.push(...)
            },
          );
        },
      ),
    );
  }
}
