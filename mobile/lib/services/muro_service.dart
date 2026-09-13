import 'dart:convert';
import '../models/muro.dart';
import 'api_client.dart';

class MuroService {
  final _apiClient = ApiClient();

  Future<List<Publicacion>> listarMuro() async {
    final response = await _apiClient.get('/Muro/publicaciones');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Publicacion.fromJson(json)).toList();
    }
    return [];
  }

  Future<bool> crearPublicacion(String contenido) async {
    final response = await _apiClient.post('/Muro/publicaciones', body: {
      'contenido': contenido,
      'imagenUrl': null,
    });
    return response.statusCode == 200;
  }

  Future<String> toggleReaccion(int publicacionId) async {
    final response = await _apiClient.post('/Muro/publicaciones/$publicacionId/reaccionar');
    final data = jsonDecode(response.body);
    return data['accion'] ?? '';
  }

  Future<List<Comentario>> listarComentarios(int publicacionId) async {
    final response = await _apiClient.get('/Muro/publicaciones/$publicacionId/comentarios');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Comentario.fromJson(json)).toList();
    }
    return [];
  }

  Future<bool> crearComentario(int publicacionId, String contenido) async {
    final response = await _apiClient.post('/Muro/publicaciones/$publicacionId/comentarios', body: {
      'contenido': contenido,
      'comentarioPadreId': null,
    });
    return response.statusCode == 200;
  }
}