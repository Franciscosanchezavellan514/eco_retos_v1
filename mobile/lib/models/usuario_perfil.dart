class UsuarioPerfil {
  final String usuarioId;
  final String uid;
  final String nombreUsuario;
  final String email;
  final String esAdmin;

  UsuarioPerfil({
    required this.usuarioId,
    required this.uid,
    required this.nombreUsuario,
    required this.email,
    required this.esAdmin,
  });

  factory UsuarioPerfil.fromJson(Map<String, dynamic> json) {
    return UsuarioPerfil(
      usuarioId: json['usuarioId'],
      uid: json['uid'],
      nombreUsuario: json['nombreUsuario'],
      email: json['email'],
      esAdmin: json['esAdmin'],
    );
  }
}