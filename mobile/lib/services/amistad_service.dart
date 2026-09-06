import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/amigo.dart';
import 'session_service.dart';

class AmistadService {
  static const String _baseUrl = 'http://localhost:5010/api';
  final _sessionService = SessionService();

  Future<List<Amigo>> listarAmigos() async {
    final token = await _sessionService.obtenerToken();
    if (token == null) return [];

    final url = Uri.parse('$_baseUrl/Amistades/mis-amigos');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Amigo.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  /// Devuelve el mensaje del backend: éxito, UID no encontrado,
  /// ya existe la relación, o auto-agregarse.
  Future<String> enviarSolicitud(String uid) async {
    final token = await _sessionService.obtenerToken();
    if (token == null) return 'Sesión no válida.';

    final url = Uri.parse('$_baseUrl/Amistades/solicitar');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'uid': uid}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return '¡Solicitud enviada!';
    }

    return data['mensaje'] ?? 'Ocurrió un error.';
  }
}