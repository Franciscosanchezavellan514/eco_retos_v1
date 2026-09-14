class MaterialTienda {
  final int materialId;
  final String nombre;
  final String? descripcion;
  final int precioPuntos;
  final String? imagenUrl;

  MaterialTienda({
    required this.materialId,
    required this.nombre,
    this.descripcion,
    required this.precioPuntos,
    this.imagenUrl,
  });

  factory MaterialTienda.fromJson(Map<String, dynamic> json) {
    return MaterialTienda(
      materialId: json['materialId'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precioPuntos: json['precioPuntos'],
      imagenUrl: json['imagenUrl'],
    );
  }
}

class MaterialInventario {
  final int materialId;
  final String nombre;
  final String? descripcion;
  final String? imagenUrl;
  final int cantidad;

  MaterialInventario({
    required this.materialId,
    required this.nombre,
    this.descripcion,
    this.imagenUrl,
    required this.cantidad,
  });

  factory MaterialInventario.fromJson(Map<String, dynamic> json) {
    return MaterialInventario(
      materialId: json['materialId'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      imagenUrl: json['imagenUrl'],
      cantidad: json['cantidad'],
    );
  }
}