import 'package:flutter/material.dart';
import '../../../models/usuario.dart';
import '/screens/modal_lenguaje/modal_lenguaje_screen.dart';
import '../lesson/lesson_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = ModalRoute.of(context)?.settings.arguments as Usuario?;

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, ${usuario?.nombre ?? 'Usuario'}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Text(
              '¿Qué es la programación?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'La programación es el proceso de crear instrucciones para que una computadora realice tareas. '
              'Te permite desarrollar aplicaciones, resolver problemas y entender cómo funciona la tecnología.\n\n'
              'Antes de comenzar tu camino en el mundo de la programación, explora el contenido disponible de cada lenguaje que ofrecemos. '
              'Así podrás elegir el que mejor se adapte a tus intereses y objetivos.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Lenguajes que aprenderás:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Tarjetas de lenguajes
            Column(
              children: [
                Card(
                  color: Colors.black54,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: InkWell(
                    onTap: () => mostrarInfoLenguajeModal(context, 'Python'),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.code, size: 32, color: Colors.blue),
                          SizedBox(width: 16),
                          Text(
                            'Python',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.check_circle_outline,
                            size: 24,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  color: Colors.black54,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: InkWell(
                    onTap:
                        () =>
                            mostrarInfoLenguajeModal(context, 'Flutter (Dart)'),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.flutter_dash,
                            size: 32,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Flutter (Dart)',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.check_circle_outline,
                            size: 24,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LessonScreen(),
                    ),
                  );
                },
                child: const Text('Iniciar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
