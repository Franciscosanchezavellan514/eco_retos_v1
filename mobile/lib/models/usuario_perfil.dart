class UsuarioPerfil {
  final int usuarioId;
  final String uid;
  final String nombreUsuario;
  final String email;
  final int puntos;
  final int monedas;
  final int nivel;
  final int rachaActual;
  final int mejorRacha;
  final int diasActivos;
  final DateTime fechaRegistro;

  UsuarioPerfil({
    required this.usuarioId,
    required this.uid,
    required this.nombreUsuario,
    required this.email,
    required this.puntos,
    required this.monedas,
    required this.nivel,
    required this.rachaActual,
    required this.mejorRacha,
    required this.diasActivos,
    required this.fechaRegistro,
  });

  factory UsuarioPerfil.fromJson(Map<String, dynamic> json) {
    return UsuarioPerfil(
      usuarioId: json['usuarioId'],
      uid: json['uid'],
      nombreUsuario: json['nombreUsuario'],
      email: json['email'],
      puntos: json['puntos'],
      monedas: json['monedas'],
      nivel: json['nivel'],
      rachaActual: json['rachaActual'],
      mejorRacha: json['mejorRacha'],
      diasActivos: json['diasActivos'],
      fechaRegistro: DateTime.parse(json['fechaRegistro']),
    );
  }

  /// Umbrales de puntos por nivel (deben coincidir con fn_CalcularNivel del backend)
  static const List<int> _umbralesNivel = [0, 100, 250, 500, 800];

  /// Puntos que faltan para el siguiente nivel (0 si ya es el nivel máximo)
  int get puntosParaSiguienteNivel {
    if (nivel >= 5) return 0;
    return _umbralesNivel[nivel] - puntos;
  }

  /// Progreso hacia el siguiente nivel, de 0.0 a 1.0 (para una barra de progreso)
  double get progresoNivel {
    if (nivel >= 5) return 1.0;
    final inicioNivelActual = _umbralesNivel[nivel - 1];
    final inicioSiguienteNivel = _umbralesNivel[nivel];
    final rango = inicioSiguienteNivel - inicioNivelActual;
    final avance = puntos - inicioNivelActual;
    return (avance / rango).clamp(0.0, 1.0);
  }
}