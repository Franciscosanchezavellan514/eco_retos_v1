class Reto {
  final int retoId;
  final String titulo;
  final String descripcion;
  final int puntosRecompensa;
  final String dificultad;

  Reto({
    required this.retoId,
    required this.titulo,
    required this.descripcion,
    required this.puntosRecompensa,
    required this.dificultad,
  });

  factory Reto.fromJson(Map<String, dynamic> json) {
    return Reto(
      retoId: json['retoId'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      puntosRecompensa: json['puntosRecompensa'],
      dificultad: json['dificultad'],
    );
  }
}