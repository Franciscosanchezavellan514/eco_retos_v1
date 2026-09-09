import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/muro.dart';
import 'session_service.dart';

class MuroService {
  static const String _baseUrl = 'http://localhost:5010/api';
  final _sessionService = SessionService();

  Future<Map<String, String>> _headers() async {
    final token = await _sessionService.obtenerToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<List<Publicacion>> listarMuro() async {
    final url = Uri.parse('$_baseUrl/Muro/publicaciones');
    final response = await http.get(url, headers: await _headers());

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Publicacion.fromJson(json)).toList();
    }
    return [];
  }

  Future<bool> crearPublicacion(String contenido) async {
    final url = Uri.parse('$_baseUrl/Muro/publicaciones');
    final response = await http.post(
      url,
      headers: await _headers(),
      body: jsonEncode({'contenido': contenido, 'imagenUrl': null}),
    );
    return response.statusCode == 200;
  }

  Future<String> toggleReaccion(int publicacionId) async {
    final url = Uri.parse('$_baseUrl/Muro/publicaciones/$publicacionId/reaccionar');
    final response = await http.post(url, headers: await _headers());
    final data = jsonDecode(response.body);
    return data['accion'] ?? '';
  }

  Future<List<Comentario>> listarComentarios(int publicacionId) async {
    final url = Uri.parse('$_baseUrl/Muro/publicaciones/$publicacionId/comentarios');
    final response = await http.get(url, headers: await _headers());

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Comentario.fromJson(json)).toList();
    }
    return [];
  }

  Future<bool> crearComentario(int publicacionId, String contenido) async {
    final url = Uri.parse('$_baseUrl/Muro/publicaciones/$publicacionId/comentarios');
    final response = await http.post(
      url,
      headers: await _headers(),
      body: jsonEncode({'contenido': contenido, 'comentarioPadreId': null}),
    );
    return response.statusCode == 200;
  }
}