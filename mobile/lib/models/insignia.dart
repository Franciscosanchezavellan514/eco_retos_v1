class Insignia {
  final int insigniaId;
  final String nombre;
  final String? descripcion;
  final String? imagenUrl;
  final DateTime fechaObtenida;

  Insignia({
    required this.insigniaId,
    required this.nombre,
    this.descripcion,
    this.imagenUrl,
    required this.fechaObtenida,
  });

  factory Insignia.fromJson(Map<String, dynamic> json) {
    return Insignia(
      insigniaId: json['insigniaId'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      imagenUrl: json['imagenUrl'],
      fechaObtenida: DateTime.parse(json['fechaObtenida']),
    );
  }
}