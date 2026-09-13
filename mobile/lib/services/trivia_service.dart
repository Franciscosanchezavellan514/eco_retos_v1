import 'dart:convert';
import '../models/trivia.dart';
import 'api_client.dart';

class TriviaService {
  final _apiClient = ApiClient();

  Future<List<CategoriaTrivia>> listarCategorias() async {
    final response = await _apiClient.get('/Trivia/categorias');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CategoriaTrivia.fromJson(json)).toList();
    }
    return [];
  }

  Future<List<Pregunta>> listarPreguntas(int categoriaId) async {
    final response = await _apiClient.get('/Trivia/categorias/$categoriaId/preguntas');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Pregunta.fromJson(json)).toList();
    }
    return [];
  }

  Future<ResultadoRespuesta?> responder(int preguntaId, int opcionId, int categoriaId) async {
    final response = await _apiClient.post('/Trivia/responder', body: {
      'preguntaId': preguntaId,
      'opcionId': opcionId,
      'categoriaId': categoriaId,
    });

    if (response.statusCode == 200) {
      return ResultadoRespuesta.fromJson(jsonDecode(response.body));
    }
    return null;
  }
}