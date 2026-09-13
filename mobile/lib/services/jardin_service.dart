import 'dart:convert';
import '../models/planta.dart';
import 'api_client.dart';

class JardinService {
  final _apiClient = ApiClient();

  Future<List<Planta>> listarCatalogo() async {
    final response = await _apiClient.get('/Tienda/plantas');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Planta.fromJson(json)).toList();
    }
    return [];
  }

  Future<List<JardinSlot>> verEstadoJardin() async {
    final response = await _apiClient.get('/Jardin/estado');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => JardinSlot.fromJson(json)).toList();
    }
    return [];
  }

  Future<String> comprarYColocar(int plantaId, int numeroSlot) async {
    final response = await _apiClient.post(
      '/Jardin/comprar-colocar',
      body: {'plantaId': plantaId, 'numeroSlot': numeroSlot},
    );
    final data = jsonDecode(response.body);
    return data['mensaje'] ?? 'Ocurrió un error.';
  }
}