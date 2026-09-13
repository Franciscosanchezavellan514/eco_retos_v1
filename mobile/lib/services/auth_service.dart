import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_response.dart';
import '../models/registro_response.dart';
import 'api_client.dart';

class AuthService {
  Future<LoginResponse?> login(String email, String password) async {
    final url = Uri.parse('${ApiClient.baseUrl}/Usuarios/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
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
    final url = Uri.parse('${ApiClient.baseUrl}/Usuarios/registrar');

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