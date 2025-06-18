import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart'; // Asegúrate de que el paquete flutter_gemini esté agregado

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final TextEditingController _textController = TextEditingController();
  final Gemini gemini = Gemini.instance;
  String? _response = ''; // Variable para guardar la respuesta de Gemini
  String? _errorMessage = ''; // Para manejar errores

  // Función para enviar la pregunta y obtener la respuesta de Gemini
  void _getGeminiResponse() async {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _errorMessage = null; // Limpiar mensajes de error previos
      });

      // Llamada a la API de Gemini para obtener una respuesta sobre el texto ingresado
      final prompt = _textController.text;
      try {
        print('Enviando solicitud a Gemini...');
        final response = await gemini.text(
          prompt,
        ); // Genera el contenido con Gemini
        print(
          'Respuesta recibida: $response',
        ); // Mostrar respuesta de Gemini en consola
        if (response != null) {
          setState(() {
            _response = response?.output; // Mostrar la respuesta de la IA
          });
        } else {
          setState(() {
            _errorMessage = 'La respuesta de la IA está vacía o nula.';
          });
        }
      } catch (e) {
        print('Error al obtener la respuesta de Gemini: $e');
        setState(() {
          _errorMessage =
              'Error al obtener la respuesta. Intenta nuevamente.'; // En caso de error
        });
      }

      _textController.clear(); // Limpiar el TextField
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lecciones')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Qué deseas aprender?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // TextField donde el usuario ingresa su pregunta o solicitud de lección
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Escribe tu pregunta sobre el tema...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getGeminiResponse,
              child: const Text('Obtener Respuesta'),
            ),
            const SizedBox(height: 20),
            // Muestra el mensaje de la respuesta o error
            if (_errorMessage != null)
              Text(_errorMessage!, style: TextStyle(color: Colors.red)),
            if (_response != null && _response!.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Respuesta de la IA:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(_response!),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
