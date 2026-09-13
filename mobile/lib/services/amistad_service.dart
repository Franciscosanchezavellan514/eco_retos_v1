import 'dart:convert';
import '../models/amigo.dart';
import 'api_client.dart';

class AmistadService {
  final _apiClient = ApiClient();

  Future<List<Amigo>> listarAmigos() async {
    final response = await _apiClient.get('/Amistades/mis-amigos');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Amigo.fromJson(json)).toList();
    }
    return [];
  }

  Future<String> enviarSolicitud(String uid) async {
    final response = await _apiClient.post('/Amistades/solicitar', body: {'uid': uid});
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return '¡Solicitud enviada!';
    }
    return data['mensaje'] ?? 'Ocurrió un error.';
  }
}