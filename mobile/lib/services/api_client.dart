import 'dart:convert';
import 'package:http/http.dart' as http;
import 'session_service.dart';

/// Centraliza las llamadas HTTP autenticadas. Si el token expiró (401),
/// intenta renovarlo automáticamente con el refresh token guardado y
/// reintenta la petición original UNA sola vez.
class ApiClient {
  static const String baseUrl = 'http://localhost:5010/api';
  final _sessionService = SessionService();

  Future<Map<String, String>> _headers() async {
    final token = await _sessionService.obtenerToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  /// Intenta renovar el token usando el refresh token guardado.
  /// Devuelve true si se renovó con éxito, false si hay que cerrar sesión.
  Future<bool> _intentarRenovarToken() async {
    final refreshToken = await _sessionService.obtenerRefreshToken();
    if (refreshToken == null) return false;

    final url = Uri.parse('$baseUrl/Usuarios/refresh-token');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode != 200) return false;

    final data = jsonDecode(response.body);

    await _sessionService.guardarSesion(
      token: data['token'],
      refreshToken: data['refreshToken'],
      usuarioId: data['usuarioId'],
      uid: data['uid'],
      nombreUsuario: data['nombreUsuario'],
    );

    return true;
  }

  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    var response = await http.get(url, headers: await _headers());

    if (response.statusCode == 401) {
      final renovado = await _intentarRenovarToken();
      if (renovado) {
        response = await http.get(url, headers: await _headers());
      }
    }

    return response;
  }

  Future<http.Response> post(String endpoint, {Object? body}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    var response = await http.post(
      url,
      headers: await _headers(),
      body: body != null ? jsonEncode(body) : null,
    );

    if (response.statusCode == 401) {
      final renovado = await _intentarRenovarToken();
      if (renovado) {
        response = await http.post(
          url,
          headers: await _headers(),
          body: body != null ? jsonEncode(body) : null,
        );
      }
    }

    return response;
  }
}