class Publicacion {
  final int publicacionId;
  final int usuarioId;
  final String nombreUsuario;
  final String contenido;
  final String? imagenUrl;
  final DateTime fechaPublicacion;
  final int totalReacciones;
  final int totalComentarios;

  Publicacion({
    required this.publicacionId,
    required this.usuarioId,
    required this.nombreUsuario,
    required this.contenido,
    this.imagenUrl,
    required this.fechaPublicacion,
    required this.totalReacciones,
    required this.totalComentarios,
  });

  factory Publicacion.fromJson(Map<String, dynamic> json) {
    return Publicacion(
      publicacionId: json['publicacionId'],
      usuarioId: json['usuarioId'],
      nombreUsuario: json['nombreUsuario'],
      contenido: json['contenido'],
      imagenUrl: json['imagenUrl'],
      fechaPublicacion: DateTime.parse(json['fechaPublicacion']),
      totalReacciones: json['totalReacciones'],
      totalComentarios: json['totalComentarios'],
    );
  }
}

class Comentario {
  final int comentarioId;
  final int usuarioId;
  final String nombreUsuario;
  final int? comentarioPadreId;
  final String contenido;
  final DateTime fechaComentario;

  Comentario({
    required this.comentarioId,
    required this.usuarioId,
    required this.nombreUsuario,
    this.comentarioPadreId,
    required this.contenido,
    required this.fechaComentario,
  });

  factory Comentario.fromJson(Map<String, dynamic> json) {
    return Comentario(
      comentarioId: json['comentarioId'],
      usuarioId: json['usuarioId'],
      nombreUsuario: json['nombreUsuario'],
      comentarioPadreId: json['comentarioPadreId'],
      contenido: json['contenido'],
      fechaComentario: DateTime.parse(json['fechaComentario']),
    );
  }
}