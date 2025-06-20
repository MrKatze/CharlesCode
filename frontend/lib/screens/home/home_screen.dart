import 'package:flutter/material.dart';
import '../../../models/usuario.dart';
import '/screens/home/maestro_home.dart';
import '/screens/home/estudiante_home.dart'; // Asegúrate de importar el Home Estudiante correcto

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = ModalRoute.of(context)?.settings.arguments as Usuario?;

    if (usuario == null) {
      return const Scaffold(body: Center(child: Text('Usuario no válido')));
    }

    // Redirige a la pantalla de Home del Maestro o Home Estudiante
    if (usuario.rol == 'Maestro') {
      return MaestroHome(usuario: usuario);
    }

    // Si es un estudiante, redirige a EstudianteHomeScreen y pasa el usuario logueado
    return EstudianteHomeScreen(usuarioLogueado: usuario);
  }
}
