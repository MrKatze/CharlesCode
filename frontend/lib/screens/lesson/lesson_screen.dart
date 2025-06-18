import 'package:flutter/material.dart';

import '/core/services/openai_service.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final OpenAIService _openAIService = OpenAIService();
  String? _response = '';

  @override
  void initState() {
    super.initState();
    _getOpenAIResponse();
  }

  Future<void> _getOpenAIResponse() async {
    final prompt = 'Explain the basics of Python programming';
    final response = await _openAIService.fetchResponse(prompt);
    setState(() {
      _response = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lesson')),
      body: Center(
        child:
            _response == null
                ? const CircularProgressIndicator()
                : Text(_response!),
      ),
    );
  }
}
