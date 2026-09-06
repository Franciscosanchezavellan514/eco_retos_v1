class Amigo {
  final int usuarioId;
  final String uid;
  final String nombreUsuario;
  final DateTime fechaDesdeQueSonAmigos;

  Amigo({
    required this.usuarioId,
    required this.uid,
    required this.nombreUsuario,
    required this.fechaDesdeQueSonAmigos,
  });

  factory Amigo.fromJson(Map<String, dynamic> json) {
    return Amigo(
      usuarioId: json['usuarioId'],
      uid: json['uid'],
      nombreUsuario: json['nombreUsuario'],
      fechaDesdeQueSonAmigos: DateTime.parse(json['fechaDesdeQueSonAmigos']),
    );
  }
}