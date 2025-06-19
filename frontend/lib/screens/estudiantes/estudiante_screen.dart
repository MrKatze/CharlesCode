import 'package:flutter/material.dart';
import '../../../models/usuario.dart';
import '/core/services/auth_service.dart';
import 'screens/estudiantes/detalle_estudiante_screen.dart';


class ScreenStudents extends StatefulWidget {
  final Usuario maestro;

  const ScreenStudents({super.key, required this.maestro});

  @override
  State<ScreenStudents> createState() => _ScreenStudentsState();
}

class _ScreenStudentsState extends State<ScreenStudents> {
  final AuthService _authService = AuthService();
  List<Usuario> estudiantes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarEstudiantes();
  }

  Future<void> _cargarEstudiantes() async {
    try {
      final data = await _authService.obtenerEstudiantes();
      setState(() {
        estudiantes = data;
        isLoading = false;
      });
    } catch (e) {
      // Manejar error (puedes mostrar un snackbar o similar)
      setState(() {
        isLoading = false;
      });
      debugPrint('Error al cargar estudiantes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Alumnos de ${widget.maestro.nombre}')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : estudiantes.isEmpty
              ? const Center(child: Text('No hay estudiantes disponibles.'))
              : ListView.builder(
                itemCount: estudiantes.length,
                itemBuilder: (context, index) {
                  final estudiante = estudiantes[index];
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(estudiante.nombre),
                    subtitle: const Text('Progreso: 70%'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetalleEstudianteScreen(estudiante: estudiante),
                    ),
                  );
                    },
                  );
                },
              ),
    );
  }
}
