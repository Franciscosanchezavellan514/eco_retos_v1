class RegistroResponse {
  final int usuarioId;

  RegistroResponse({required this.usuarioId});

  factory RegistroResponse.fromJson(Map<String, dynamic> json) {
    return RegistroResponse(usuarioId: json['usuarioId']);
  }
}