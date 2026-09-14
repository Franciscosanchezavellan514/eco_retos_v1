import 'dart:convert';
import '../models/material.dart';
import 'api_client.dart';

class MaterialService {
  final _apiClient = ApiClient();

  Future<List<MaterialTienda>> listarTienda() async {
    final response = await _apiClient.get('/Materiales/tienda');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => MaterialTienda.fromJson(json)).toList();
    }
    return [];
  }

  Future<String> comprar(int materialId, int cantidad) async {
    final response = await _apiClient.post(
      '/Materiales/$materialId/comprar',
      body: {'cantidad': cantidad},
    );
    final data = jsonDecode(response.body);
    return data['mensaje'] ?? 'Ocurrió un error.';
  }

  Future<List<MaterialInventario>> listarInventario() async {
    final response = await _apiClient.get('/Materiales/inventario');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => MaterialInventario.fromJson(json)).toList();
    }
    return [];
  }
}