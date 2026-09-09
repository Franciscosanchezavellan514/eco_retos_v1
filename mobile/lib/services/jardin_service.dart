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

  /// Lista el catálogo de plantas con sus precios (usado para mostrar
  /// las opciones dentro del diálogo del Jardín, ya no hay pantalla
  /// de Tienda separada).
  Future<List<Planta>> listarCatalogo() async {
    final url = Uri.parse('$_baseUrl/Tienda/plantas');
    final response = await http.get(url, headers: await _headers());

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Planta.fromJson(json)).toList();
    }
    return [];
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

  /// Compra y coloca la planta en un solo paso (cobra monedas cada vez,
  /// no hay "desbloqueo" - igual que el prototipo original).
  Future<String> comprarYColocar(int plantaId, int numeroSlot) async {
    final url = Uri.parse('$_baseUrl/Jardin/comprar-colocar');
    final response = await http.post(
      url,
      headers: await _headers(),
      body: jsonEncode({'plantaId': plantaId, 'numeroSlot': numeroSlot}),
    );
    final data = jsonDecode(response.body);
    return data['mensaje'] ?? 'Ocurrió un error.';
  }
}