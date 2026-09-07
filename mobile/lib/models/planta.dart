class Planta {
  final int plantaId;
  final String nombre;
  final int precioMonedas;
  final String? imagenUrl;

  Planta({
    required this.plantaId,
    required this.nombre,
    required this.precioMonedas,
    this.imagenUrl,
  });

  factory Planta.fromJson(Map<String, dynamic> json) {
    return Planta(
      plantaId: json['plantaId'],
      nombre: json['nombre'],
      precioMonedas: json['precioMonedas'],
      imagenUrl: json['imagenUrl'],
    );
  }
}

class JardinSlot {
  final int numeroSlot;
  final int plantaId;
  final String nombrePlanta;
  final DateTime fechaColocacion;

  JardinSlot({
    required this.numeroSlot,
    required this.plantaId,
    required this.nombrePlanta,
    required this.fechaColocacion,
  });

  factory JardinSlot.fromJson(Map<String, dynamic> json) {
    return JardinSlot(
      numeroSlot: json['numeroSlot'],
      plantaId: json['plantaId'],
      nombrePlanta: json['nombrePlanta'],
      fechaColocacion: DateTime.parse(json['fechaColocacion']),
    );
  }
}