import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';  // Asegúrate de tener el paquete flutter_gemini

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final TextEditingController _textController = TextEditingController();
  String? _response = '';
  String? _errorMessage = '';

  // Función para obtener respuesta de la IA
  void _getGeminiResponse() async {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _errorMessage = null;
      });

      final prompt = _textController.text;
      try {
        // Verificamos si la pregunta está relacionada con la programación o sentimientos relacionados
        if (_isProgrammingRelated(prompt) || _isEmotionalSupportRequest(prompt)) {
          // Si la pregunta tiene que ver con programación o emociones relacionadas, la enviamos a Gemini
          final response = await Gemini.instance.text(prompt);
          if (response != null) {
            setState(() {
              _response = response.output;
            });
          } else {
            setState(() {
              _errorMessage = 'La respuesta de la IA está vacía o nula.';
            });
          }
        } else if (_isLearningInterestRequest(prompt)) {
          // Si la pregunta es sobre el interés de aprender programación
          setState(() {
            _response = '¡Genial! Empecemos a aprender. ¿Qué lenguaje de programación te gustaría aprender?';
          });
        } else {
          // Si la pregunta no está relacionada con programación, respondemos con un mensaje chistoso
          setState(() {
            _response = '¿Eso tiene que ver con programación? ¡Pregunta algo sobre código!';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Error al obtener la respuesta. Intenta nuevamente.';
        });
      }

      _textController.clear();
    }
  }

  // Función para verificar si el texto es sobre programación
  bool _isProgrammingRelated(String text) {
    final programmingKeywords = [
      'programación', 'código', 'lenguaje', 'algoritmo', 'función', 
      'variable', 'debugging', 'compilador', 'estructura de datos', 
      'Python', 'Java', 'C++', 'Dart', 'Flutter', 'JavaScript', 'API'
    ];
    
    String lowerCaseText = text.toLowerCase();

    // Verificamos si alguna palabra clave aparece en el texto
    for (var keyword in programmingKeywords) {
      if (lowerCaseText.contains(keyword)) {
        return true;
      }
    }

    return false;
  }

  // Función para detectar si la pregunta está relacionada con emociones o motivación
  bool _isEmotionalSupportRequest(String text) {
    final emotionalKeywords = [
      'triste', 'bloqueo', 'frustrado', 'no puedo', 'me siento mal', 
      'no sé programar', 'me siento perdido', 'estoy atascado'
    ];

    String lowerCaseText = text.toLowerCase();

    // Verificamos si alguna palabra clave aparece en el texto
    for (var keyword in emotionalKeywords) {
      if (lowerCaseText.contains(keyword)) {
        return true;
      }
    }

    return false;
  }

  // Función para detectar si el texto es sobre el interés de aprender programación
  bool _isLearningInterestRequest(String text) {
    final learningKeywords = [
      'quiero aprender a programar', 'cómo aprender a programar', 'deseo aprender a programar', 
      'me gustaría aprender a programar', 'empezar a programar'
    ];

    String lowerCaseText = text.toLowerCase();

    // Verificamos si alguna frase clave aparece en el texto
    for (var keyword in learningKeywords) {
      if (lowerCaseText.contains(keyword)) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aprendiendo con la IA'),
        backgroundColor: Colors.deepPurple,
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Realiza alguna pregunta enfocada a la programación?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Escribe tu pregunta sobre programación...',
                hintStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.deepPurple[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getGeminiResponse,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,  // Color de fondo
                foregroundColor: Colors.white,       // Color del texto
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),  // Bordes redondeados
                ),
              ),
              child: const Text('Obtener Respuesta'),
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null)
              Text(_errorMessage!, style: TextStyle(color: Colors.red)),
            
            // Aquí usamos un Expanded y un SingleChildScrollView para manejar el contenido de manera flexible
            Expanded(
              child: SingleChildScrollView(
                child: _response != null && _response!.isNotEmpty
                    ? Text(
                        'Respuesta de la IA: $_response',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      )
                    : const SizedBox.shrink(),  // Si no hay respuesta, no muestra nada
              ),
            ),
          ],
        ),
      ),
    );
  }
}

