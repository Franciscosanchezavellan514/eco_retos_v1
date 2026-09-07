import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/planta.dart';
import 'session_service.dart';

class JardinService {
  static const String _baseUrl = 'http://localhost:5010/api';
  final _sessionService = SessionService();

  Future<Map<String, String>> _headers() async {
    final token = await _sessionService.obtenerToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<List<Planta>> listarTienda() async {
    final url = Uri.parse('$_baseUrl/Tienda/plantas');
    final response = await http.get(url, headers: await _headers());

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Planta.fromJson(json)).toList();
    }
    return [];
  }

  Future<String> comprarPlanta(int plantaId) async {
    final url = Uri.parse('$_baseUrl/Tienda/plantas/$plantaId/comprar');
    final response = await http.post(url, headers: await _headers());
    final data = jsonDecode(response.body);
    return data['mensaje'] ?? 'Ocurrió un error.';
  }

  Future<List<JardinSlot>> verEstadoJardin() async {
    final url = Uri.parse('$_baseUrl/Jardin/estado');
    final response = await http.get(url, headers: await _headers());

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => JardinSlot.fromJson(json)).toList();
    }
    return [];
  }

  Future<String> colocarPlanta(int numeroSlot, int plantaId) async {
    final url = Uri.parse('$_baseUrl/Jardin/colocar');
    final response = await http.post(
      url,
      headers: await _headers(),
      body: jsonEncode({'numeroSlot': numeroSlot, 'plantaId': plantaId}),
    );
    final data = jsonDecode(response.body);
    return data['mensaje'] ?? 'Ocurrió un error.';
  }
}