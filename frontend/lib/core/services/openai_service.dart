import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String _apiKey = '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';  // Cambia por tu clave de OpenAI
  final String _baseUrl = 'https://api.openai.com/v1/completions';

  Future<String?> fetchResponse(String prompt) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': 'text-davinci-003',  // Cambia el modelo según lo que necesites
        'prompt': prompt,
        'max_tokens': 100,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['text'];
    } else {
      print('Error: ${response.statusCode}');
      return null;
    }
  }
}
