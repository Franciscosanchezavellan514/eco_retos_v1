import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_response.dart';
import '../models/registro_response.dart';

class AuthService {
  // IMPORTANTE: mientras desarrollas en modo web (Chrome/Brave), localhost
  // funciona directo porque el navegador y el backend corren en la misma máquina.
  // Cuando pruebes en tu Xiaomi real más adelante, esto va a necesitar cambiar
  // a la IP de tu PC en la red local (ej: http://192.168.1.X:5010), porque el
  // celular no entiende "localhost" como tu propia PC.
  static const String _baseUrl = 'http://localhost:5010/api';

  Future<LoginResponse?> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/Usuarios/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return LoginResponse.fromJson(data);
    } else {
      return null;
    }
  }

  Future<RegistroResponse?> registrar(
    String nombreUsuario,
    String email,
    String password,
  ) async {
    final url = Uri.parse('$_baseUrl/Usuarios/registrar');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombreUsuario': nombreUsuario,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return RegistroResponse.fromJson(data);
    } else {
      return null;
    }
  }
}