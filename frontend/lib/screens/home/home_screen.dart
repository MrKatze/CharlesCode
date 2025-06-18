import 'package:flutter/material.dart';
import '../../../models/usuario.dart';
import '/screens/home/maestro_home.dart';
import '/screens/home/estudiante_home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = ModalRoute.of(context)?.settings.arguments as Usuario?;

    if (usuario == null) {
      return const Scaffold(body: Center(child: Text('Usuario no válido')));
    }

    if (usuario.rol == 'Maestro') {
      return MaestroHome(usuario: usuario);
    }

    return EstudianteHome(usuario: usuario);
  }
}
