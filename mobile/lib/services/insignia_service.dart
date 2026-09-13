import 'dart:convert';
import '../models/insignia.dart';
import 'api_client.dart';

class InsigniaService {
  final _apiClient = ApiClient();

  Future<List<Insignia>> listarMisInsignias() async {
    final response = await _apiClient.get('/Insignias/mis-insignias');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Insignia.fromJson(json)).toList();
    }
    return [];
  }
}