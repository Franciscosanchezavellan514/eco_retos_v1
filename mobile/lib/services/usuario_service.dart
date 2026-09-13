import 'dart:convert';
import '../models/usuario_perfil.dart';
import 'api_client.dart';

class UsuarioService {
  final _apiClient = ApiClient();

  Future<UsuarioPerfil?> obtenerMiPerfil() async {
    final response = await _apiClient.get('/Usuarios/me');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UsuarioPerfil.fromJson(data);
    } else {
      return null;
    }
  }
}