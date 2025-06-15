import 'package:flutter/material.dart';
import '../../../models/usuario.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = ModalRoute.of(context)?.settings.arguments as Usuario?;

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, ${usuario?.nombre ?? 'Usuario'}'),
      ),
      body: Center(
        child: Text(
          'Has iniciado sesión como ${usuario?.rol ?? 'desconocido'}\nCorreo: ${usuario?.correo ?? 'N/A'}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
