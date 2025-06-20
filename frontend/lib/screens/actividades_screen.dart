import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/vs2015.dart';

class ActivitiesScreen extends StatefulWidget {
  final String topic;

  const ActivitiesScreen({super.key, required this.topic});

  @override
  // ignore: library_private_types_in_public_api
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen>
    with TickerProviderStateMixin {
  String _question = '';
  List<String> _options = [];
  String? _selectedAnswer;
  String? _feedback;

  int _activityIndex =
      0; // Índice para llevar el control de la actividad actual
  int _correctAnswers = 0; // Contador de respuestas correctas
  final List<String> _correctAnswersList = []; // Lista de respuestas correctas

  // Variable para controlar la visibilidad del botón "Verificar Respuesta"
  bool _isActivityGenerated = false;
  bool _isCompleted =
      false; // Variable para indicar si se han completado todas las actividades

  // Animaciones
  late AnimationController _controller;
  late Animation<double> _animation;

  // NUEVO: Estado para la explicación del tema
  String? _topicExplanation;
  bool _isLoadingExplanation = true;

  @override
  void initState() {
    super.initState();

    // Animación para el botón "Generar actividad"
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Empezar la animación inmediatamente
    _controller.forward();

    _fetchTopicExplanation(); // Obtener explicación al iniciar
  }

  // NUEVO: Obtener explicación detallada del tema desde Gemini
  Future<void> _fetchTopicExplanation() async {
    setState(() {
      _isLoadingExplanation = true;
    });
    final prompt =
        'Explica de forma detallada, clara y sencilla el siguiente tema de programación, usando ejemplos de código si es relevante. Si das código, ponlo en un bloque Markdown: ${widget.topic}';
    try {
      final response = await Gemini.instance.text(prompt);
      if (response != null && response.content != null) {
        String? explanation;
        final parts = response.content!.parts;
        if (parts != null && parts.isNotEmpty) {
          final part = parts.first;
          if (part is TextPart) {
            explanation = part.text;
          } else {
            explanation = part.toString(); // fallback
          }
        }
        setState(() {
          _topicExplanation = explanation ?? '';
          _isLoadingExplanation = false;
        });
      } else {
        setState(() {
          _topicExplanation = 'No se pudo obtener la explicación.';
          _isLoadingExplanation = false;
        });
      }
    } catch (e) {
      setState(() {
        _topicExplanation = 'Error al obtener la explicación.';
        _isLoadingExplanation = false;
      });
    }
  }

  // NUEVO: Widget para mostrar explicación con bloques de código resaltados
  Widget _buildExplanationWidget() {
    if (_isLoadingExplanation) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_topicExplanation == null || _topicExplanation!.isEmpty) {
      return const Text('No hay explicación disponible.');
    }
    // Buscar bloques de código en Markdown (```)
    final codeRegExp = RegExp(r'```([a-zA-Z]*)\n([\s\S]*?)```');
    final matches = codeRegExp.allMatches(_topicExplanation!);
    if (matches.isEmpty) {
      // Solo texto, sin bloques de código
      return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade900.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          _topicExplanation!,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      );
    }
    // Si hay bloques de código, dividir el texto y mostrar con highlight
    List<Widget> children = [];
    int lastEnd = 0;
    for (final match in matches) {
      if (match.start > lastEnd) {
        children.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              _topicExplanation!.substring(lastEnd, match.start),
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        );
      }
      final language = match.group(1) ?? 'python';
      final code = match.group(2) ?? '';
      children.add(
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: HighlightView(
            code,
            language: language.isEmpty ? 'python' : language,
            theme: vs2015Theme,
            padding: const EdgeInsets.all(12),
            textStyle: const TextStyle(fontFamily: 'Fira Mono', fontSize: 15),
          ),
        ),
      );
      lastEnd = match.end;
    }
    if (lastEnd < _topicExplanation!.length) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            _topicExplanation!.substring(lastEnd),
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade900.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  // Función para generar actividades dinámicas con una estructura clara
  void _generateActivity() async {
    setState(() {
      _question = ''; // Limpiar la pregunta previa
      _options = []; // Limpiar las opciones previas
      _feedback = null; // Limpiar retroalimentación previa
      _isActivityGenerated = true; // Mostrar el botón de verificar respuesta
    });

    // Solicitamos a Gemini una respuesta estructurada con el tema seleccionado
    final prompt = '''
    Genera una pregunta de opción múltiple sobre el tema: ${widget.topic}. La respuesta debe seguir este formato:
    Pregunta: [Pregunta aquí]
    Opciones:
    a) [Respuesta A]
    b) [Respuesta B]
    c) [Respuesta C]
    d) [Respuesta D]
    ''';

    try {
      print('Enviando solicitud a Gemini...');
      final response = await Gemini.instance.text(prompt);
      print('Respuesta de actividades recibida: $response');

      if (response != null && response.content != null) {
        final content = response.content;

        // Extraemos la pregunta y las opciones de respuesta
        setState(() {
          _question = _extractTextFromParts(content?.parts);
          _options = _extractOptionsFromParts(content?.parts);
        });

        // Agregar la respuesta correcta a la lista
        if (_options.isNotEmpty) {
          _correctAnswersList.add(
            _options.first,
          ); // La respuesta correcta es la primera opción
        }
      } else {
        setState(() {
          _question = 'No se pudo obtener la actividad.';
        });
      }
    } catch (e) {
      print('Error al obtener actividades de Gemini: $e');
      setState(() {
        _question = 'Error al obtener las actividades. Intenta nuevamente.';
      });
    }
  }

  // Función para extraer el texto de las partes (p. ej., pregunta)
  String _extractTextFromParts(List<Part>? parts) {
    if (parts == null) return '';
    for (var part in parts) {
      if (part is TextPart) {
        String text = part.text ?? '';

        // Eliminar el texto de "Opciones:" y cualquier cosa que venga después
        final optionsIndex = text.indexOf('Opciones:');
        if (optionsIndex != -1) {
          text =
              text.substring(0, optionsIndex).trim(); // Queda solo la pregunta
        }

        // Eliminar la línea de "Respuesta correcta:" y todo lo que siga
        final answerIndex = text.indexOf('Respuesta correcta:');
        if (answerIndex != -1) {
          text =
              text
                  .substring(0, answerIndex)
                  .trim(); // Quita la respuesta correcta
        }

        return text; // Regresa solo la pregunta sin opciones ni respuesta correcta
      }
    }
    return '';
  }

  // Función para extraer las opciones de respuesta de la respuesta estructurada
  List<String> _extractOptionsFromParts(List<Part>? parts) {
    List<String> options = [];
    if (parts == null) return options;
    for (var part in parts) {
      if (part is TextPart) {
        String text = part.text ?? '';

        // Buscamos las opciones dentro de la respuesta estructurada
        final optionPattern = RegExp(r'\b[a-d]\)\s*([^\n]+)');
        final matches = optionPattern.allMatches(text);
        for (var match in matches) {
          options.add(
            match.group(1)!,
          ); // Extraemos las opciones y las agregamos a la lista
        }
      }
    }
    return options;
  }

  // Función para verificar la respuesta seleccionada
  void _checkAnswer() {
    setState(() {
      if (_selectedAnswer == _correctAnswersList[_activityIndex]) {
        _correctAnswers++; // Aumentamos el contador de respuestas correctas
        _feedback = '¡Correcto! ¡Bien hecho!';
      } else {
        _feedback =
            'Incorrecto. La respuesta correcta es: ${_correctAnswersList[_activityIndex]}';
      }
    });

    // Después de un retardo de 1 segundo, avanzamos a la siguiente actividad
    Future.delayed(const Duration(seconds: 1), () {
      if (_activityIndex < 4) {
        setState(() {
          _activityIndex++; // Aumentamos el índice para la siguiente actividad
          _selectedAnswer = null; // Limpiamos la respuesta seleccionada
          _generateActivity(); // Generamos la siguiente actividad
        });
      } else {
        // Al finalizar las 5 actividades, mostramos la puntuación final
        _showFinalScore();
        setState(() {
          _isCompleted = true; // Marcamos que las actividades se han completado
        });
      }
    });
  }

  // Función para mostrar la puntuación final
  void _showFinalScore() {
    String resultMessage = 'Tu puntuación es $_correctAnswers/5.';
    if (_correctAnswers == 5) {
      resultMessage += '\n¡Excelente! ¡Perfecto!';
    } else if (_correctAnswers >= 3) {
      resultMessage += '\n¡Buen trabajo!';
    } else {
      resultMessage += '\nSigue practicando, puedes mejorar.';
    }

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Resultado Final'),
            content: Text(resultMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Aceptar'),
              ),
            ],
          ),
    );
  }

  // Función para reiniciar las actividades
  void _restartActivities() {
    setState(() {
      _activityIndex = 0;
      _correctAnswers = 0;
      _correctAnswersList.clear();
      _isActivityGenerated = false;
      _selectedAnswer = null;
      _feedback = null;
      _isCompleted = false; // Reiniciamos el estado de completado
    });
    _generateActivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.topic,
        ), // Aquí cambia el título según el tema seleccionado
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        // Hacemos la pantalla desplazable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Mostrar explicación antes del cuestionario
            _buildExplanationWidget(),
            const SizedBox(height: 10),
            // Instrucción al estudiante
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _animation,
              child: const Text(
                'Presiona "Generar actividad" para obtener 5 actividades sobre el tema seleccionado y responderlas. ¡Veamos qué tanto sabes!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ), // Texto de instrucciones en rojo
              ),
            ),
            const SizedBox(height: 20),

            // Botón para generar actividades con animación
            FadeTransition(
              opacity: _animation,
              child: ElevatedButton(
                onPressed: _generateActivity,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Color del botón de generar
                ),
                child: const Text('Generar actividad'),
              ),
            ),
            const SizedBox(height: 20),

            // Mostrar la pregunta y opciones de respuesta
            if (_question.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _question, // Muestra solo la pregunta sin respuesta correcta
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ), // Actividad en blanco
                  ),
                  const SizedBox(height: 20),
                  ..._options.map(
                    (option) => RadioListTile<String>(
                      title: Text(
                        option,
                        style: const TextStyle(color: Colors.white),
                      ), // Opciones en blanco
                      value: option,
                      groupValue: _selectedAnswer,
                      onChanged: (value) {
                        setState(() {
                          _selectedAnswer = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),

            // Mostrar el botón de "Verificar Respuesta" solo si la actividad fue generada
            if (_isActivityGenerated)
              FadeTransition(
                opacity: _animation,
                child: ElevatedButton(
                  onPressed: _checkAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green, // Color del botón de verificar
                  ),
                  child: const Text('Verificar Respuesta'),
                ),
              ),
            const SizedBox(height: 20),

            // Retroalimentación de la respuesta
            if (_feedback != null)
              Text(
                _feedback!,
                style: TextStyle(
                  color:
                      _feedback!.contains('Correcto')
                          ? Colors.green
                          : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 20),

            // Botón para reiniciar actividades después de completar todas
            if (_isCompleted)
              ElevatedButton(
                onPressed: _restartActivities,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.orange, // Color del botón de reiniciar
                ),
                child: const Text('Reiniciar actividades'),
              ),
          ],
        ),
      ),
    );
  }
}
