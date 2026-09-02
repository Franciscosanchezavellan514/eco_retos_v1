import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reto.dart';
import 'session_service.dart';

class RetoService {
  static const String _baseUrl = 'http://localhost:5010/api';
  final _sessionService = SessionService();

  Future<List<Reto>> listarActivos() async {
    final token = await _sessionService.obtenerToken();
    if (token == null) return [];

    final url = Uri.parse('$_baseUrl/Retos/activos');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Reto.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  /// Devuelve el mensaje del backend (éxito o el motivo del rechazo:
  /// ya completado, materiales insuficientes, etc.)
  Future<String> completar(int retoId) async {
    final token = await _sessionService.obtenerToken();
    if (token == null) return 'Sesión no válida.';

    final url = Uri.parse('$_baseUrl/Retos/$retoId/completar');

    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);
    return data['mensaje'] ?? 'Ocurrió un error.';
  }
}