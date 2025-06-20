import 'package:flutter/material.dart';
import 'package:frontend/screens/actividades/actividades_estudiante_screen.dart';
import 'package:frontend/screens/actividades_screen.dart';
import 'package:frontend/screens/lesson/lesson_screen.dart';
import 'package:frontend/screens/login/login_screen.dart';
import '../../models/usuario.dart';

class EstudianteHomeScreen extends StatelessWidget {
  final Usuario usuarioLogueado;
  const EstudianteHomeScreen({super.key, required this.usuarioLogueado});

  @override
  Widget build(BuildContext context) {
    // Usa directamente usuarioLogueado, no intentes obtenerlo de ModalRoute
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido al área de estudiante'),
        backgroundColor: Colors.deepPurple,
        actions: [
          // Icono de deslogueo en la parte superior derecha
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // Redirige al usuario a la pantalla de login
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          const LoginScreen(), // Redirigimos a la pantalla de login
                ),
              );
            },
          ),
          // Botón para ver actividades asignadas
          IconButton(
            icon: const Icon(Icons.assignment),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ActividadesEstudianteScreen(
                        idEstudiante: usuarioLogueado.idUsuario,
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Hacemos que la pantalla sea desplazable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Descripción de qué es la programación
            const Text(
              '¿Qué es la programación?',
              style: TextStyle(
                fontSize: 24, // Tamaño grande para el subtítulo
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 142, 255, 77),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'La programación es el proceso de diseñar y crear instrucciones que le indican a una computadora cómo realizar tareas. '
              'Es la base para crear aplicaciones, juegos, sitios web y mucho más.',
              style: TextStyle(
                fontSize: 18, // Tamaño de texto adecuado
                color: Color.fromARGB(
                  221,
                  255,
                  255,
                  255,
                ), // Color negro para el texto
                height: 1.5, // Espaciado entre líneas
              ),
            ),
            const SizedBox(height: 30),

            // Título para los temas
            const Text(
              'Python: ',
              style: TextStyle(
                fontSize: 28, // Título grande
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 142, 255, 77),
              ),
            ),
            const SizedBox(height: 20),

            // Crear los botones o tarjetas para cada tema
            _buildTopicButton(context, 'Introducción a Python'),
            _buildTopicButton(context, 'Variables y tipos de datos en Python'),
            _buildTopicButton(context, 'Estructuras de control en Python'),
            _buildTopicButton(context, 'Funciones en Python'),
            _buildTopicButton(context, 'Manejo de errores en Python'),
            _buildTopicButton(context, 'Módulos y paquetes en Python'),
            _buildTopicButton(context, 'Proyecto práctico en Python'),

            const SizedBox(height: 30),

            // Agregar tarjeta o botón para hablar con la IA
            _buildTalkToIACard(context),
          ],
        ),
      ),
    );
  }

  // Método para crear un botón que redirige a la pantalla de actividades con el tema seleccionado
  Widget _buildTopicButton(BuildContext context, String topic) {
    return Card(
      color: Colors.black54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: InkWell(
        onTap: () {
          // Redirigimos a la pantalla de actividades con el tema seleccionado
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ActivitiesScreen(
                    topic: topic,
                  ), // Pasamos el tema a la pantalla de actividades
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.code, size: 32, color: Colors.blue),
              const SizedBox(width: 16),
              Expanded(
                // Esto ayuda a que el texto se ajuste al tamaño disponible
                child: Text(
                  topic,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  overflow:
                      TextOverflow
                          .visible, // Permite el texto en varias líneas si es necesario
                  maxLines:
                      null, // Permite que el texto ocupe tantas líneas como sea necesario
                ),
              ),
              const Icon(Icons.chevron_right, size: 24, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  // Método para crear la tarjeta de "Habla con la IA sobre programación"
  Widget _buildTalkToIACard(BuildContext context) {
    return Card(
      color: Colors.deepPurple,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: InkWell(
        onTap: () {
          // Redirigimos a la pantalla de Lecciones donde el estudiante puede interactuar con la IA
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      const LessonScreen(), // Aquí redirigimos a la pantalla de lecciones
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: const [
              Icon(Icons.chat_bubble, size: 32, color: Colors.white),
              SizedBox(width: 16),
              // Hacemos que el texto sea más flexible y ocupe el espacio disponible
              Flexible(
                child: Text(
                  'Habla con la IA sobre programación',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  overflow:
                      TextOverflow
                          .visible, // Permite el texto en varias líneas si es necesario
                  maxLines:
                      null, // Permite que el texto ocupe tantas líneas como sea necesario
                ),
              ),
              Spacer(),
              Icon(Icons.chevron_right, size: 24, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
