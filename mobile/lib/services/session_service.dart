import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _keyToken = 'token';
  static const _keyRefreshToken = 'refreshToken';
  static const _keyUsuarioId = 'usuarioId';
  static const _keyUid = 'uid';
  static const _keyNombreUsuario = 'nombreUsuario';

  Future<void> guardarSesion({
    required String token,
    required String refreshToken,
    required int usuarioId,
    required String uid,
    required String nombreUsuario,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyRefreshToken, refreshToken);
    await prefs.setInt(_keyUsuarioId, usuarioId);
    await prefs.setString(_keyUid, uid);
    await prefs.setString(_keyNombreUsuario, nombreUsuario);
  }

  Future<String?> obtenerToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  Future<String?> obtenerRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRefreshToken);
  }

  Future<String?> obtenerNombreUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyNombreUsuario);
  }

  Future<bool> haySesionActiva() async {
    final token = await obtenerToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}