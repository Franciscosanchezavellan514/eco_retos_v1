class MaterialRequerido {
  final int materialId;
  final String nombreMaterial;
  final int cantidadRequerida;
  final int cantidadDisponible;
  final bool cumple;

  MaterialRequerido({
    required this.materialId,
    required this.nombreMaterial,
    required this.cantidadRequerida,
    required this.cantidadDisponible,
    required this.cumple,
  });

  factory MaterialRequerido.fromJson(Map<String, dynamic> json) {
    return MaterialRequerido(
      materialId: json['materialId'],
      nombreMaterial: json['nombreMaterial'],
      cantidadRequerida: json['cantidadRequerida'],
      cantidadDisponible: json['cantidadDisponible'],
      cumple: json['cumple'],
    );
  }
}

class Reto {
  final int retoId;
  final String titulo;
  final String descripcion;
  final int puntosRecompensa;
  final String dificultad;
  final List<MaterialRequerido> materiales;
  final bool puedeCompletarse;

  Reto({
    required this.retoId,
    required this.titulo,
    required this.descripcion,
    required this.puntosRecompensa,
    required this.dificultad,
    required this.materiales,
    required this.puedeCompletarse,
  });

  factory Reto.fromJson(Map<String, dynamic> json) {
    return Reto(
      retoId: json['retoId'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      puntosRecompensa: json['puntosRecompensa'],
      dificultad: json['dificultad'],
      materiales: (json['materiales'] as List)
          .map((m) => MaterialRequerido.fromJson(m))
          .toList(),
      puedeCompletarse: json['puedeCompletarse'],
    );
  }
}