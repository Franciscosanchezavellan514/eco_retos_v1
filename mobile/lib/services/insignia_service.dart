import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/insignia.dart';
import 'session_service.dart';

class InsigniaService {
  static const String _baseUrl = 'http://localhost:5010/api';
  final _sessionService = SessionService();

  Future<List<Insignia>> listarMisInsignias() async {
    final token = await _sessionService.obtenerToken();
    if (token == null) return [];

    final url = Uri.parse('$_baseUrl/Insignias/mis-insignias');
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Insignia.fromJson(json)).toList();
    }
    return [];
  }
}