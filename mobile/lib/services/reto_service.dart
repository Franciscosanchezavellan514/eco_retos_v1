import 'dart:convert';
import '../models/reto.dart';
import 'api_client.dart';

class RetoService {
  final _apiClient = ApiClient();

  Future<List<Reto>> listarActivos() async {
    final response = await _apiClient.get('/Retos/activos');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Reto.fromJson(json)).toList();
    }
    return [];
  }

  Future<String> completar(int retoId) async {
    final response = await _apiClient.post('/Retos/$retoId/completar');
    final data = jsonDecode(response.body);
    return data['mensaje'] ?? 'Ocurrió un error.';
  }
}