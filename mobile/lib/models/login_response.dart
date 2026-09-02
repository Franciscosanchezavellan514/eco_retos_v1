class LoginResponse {
  final int usuarioId;
  final String uid;
  final String nombreUsuario;
  final String token;
  final String refreshToken;

  LoginResponse({
    required this.usuarioId,
    required this.uid,
    required this.nombreUsuario,
    required this.token,
    required this.refreshToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      usuarioId: json['usuarioId'],
      uid: json['uid'],
      nombreUsuario: json['nombreUsuario'],
      token: json['token'],
      refreshToken: json['refreshToken'],
    );
  }
}