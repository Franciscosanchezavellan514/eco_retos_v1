import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trivia.dart';
import 'session_service.dart';

class TriviaService {
  static const String _baseUrl = 'http://localhost:5010/api';
  final _sessionService = SessionService();

  Future<Map<String, String>> _headers() async {
    final token = await _sessionService.obtenerToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<List<CategoriaTrivia>> listarCategorias() async {
    final url = Uri.parse('$_baseUrl/Trivia/categorias');
    final response = await http.get(url, headers: await _headers());

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CategoriaTrivia.fromJson(json)).toList();
    }
    return [];
  }

  Future<List<Pregunta>> listarPreguntas(int categoriaId) async {
    final url = Uri.parse('$_baseUrl/Trivia/categorias/$categoriaId/preguntas');
    final response = await http.get(url, headers: await _headers());

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Pregunta.fromJson(json)).toList();
    }
    return [];
  }

  Future<ResultadoRespuesta?> responder(int preguntaId, int opcionId, int categoriaId) async {
    final url = Uri.parse('$_baseUrl/Trivia/responder');
    final response = await http.post(
      url,
      headers: await _headers(),
      body: jsonEncode({
        'preguntaId': preguntaId,
        'opcionId': opcionId,
        'categoriaId': categoriaId,
      }),
    );

    if (response.statusCode == 200) {
      return ResultadoRespuesta.fromJson(jsonDecode(response.body));
    }
    return null;
  }
}