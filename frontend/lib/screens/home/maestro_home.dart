import 'package:flutter/material.dart';
import '../../../models/usuario.dart';
import '/screens/login/login_screen.dart';
import '/screens/estudiantes/estudiante_screen.dart';

class MaestroHome extends StatelessWidget {
  final Usuario usuario;

  const MaestroHome({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panel del Maestro: ${usuario.nombre}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Acciones disponibles:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            MaestroCard(
              icon: Icons.group,
              label: 'Ver alumnos registrados',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScreenStudents(maestro: usuario),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            MaestroCard(
              icon: Icons.code,
              label: 'Actividades Python',
              onTap: () {
                // TODO
              },
            ),
            const SizedBox(height: 12),
            MaestroCard(
              icon: Icons.flutter_dash,
              label: 'Actividades Flutter',
              onTap: () {
                // TODO
              },
            ),
            const SizedBox(height: 12),
            MaestroCard(
              icon: Icons.add_circle_outline,
              label: 'Crear nueva actividad',
              onTap: () {
                // TODO
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MaestroCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const MaestroCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, size: 32, color: Colors.blue),
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const Icon(Icons.chevron_right, size: 24, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
