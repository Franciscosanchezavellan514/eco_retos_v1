import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario_perfil.dart';
import 'session_service.dart';

class UsuarioService {
  static const String _baseUrl = 'http://localhost:5010/api';
  final _sessionService = SessionService();

  Future<UsuarioPerfil?> obtenerMiPerfil() async {
    final token = await _sessionService.obtenerToken();
    if (token == null) return null;

    final url = Uri.parse('$_baseUrl/Usuarios/me');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UsuarioPerfil.fromJson(data);
    } else {
      return null;
    }
  }
}