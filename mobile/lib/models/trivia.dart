class CategoriaTrivia {
  final int categoriaId;
  final String nombre;
  final String grupo;
  final String dificultad;

  CategoriaTrivia({
    required this.categoriaId,
    required this.nombre,
    required this.grupo,
    required this.dificultad,
  });

  factory CategoriaTrivia.fromJson(Map<String, dynamic> json) {
    return CategoriaTrivia(
      categoriaId: json['categoriaId'],
      nombre: json['nombre'],
      grupo: json['grupo'],
      dificultad: json['dificultad'],
    );
  }
}

class OpcionPregunta {
  final int opcionId;
  final String texto;

  OpcionPregunta({required this.opcionId, required this.texto});

  factory OpcionPregunta.fromJson(Map<String, dynamic> json) {
    return OpcionPregunta(opcionId: json['opcionId'], texto: json['texto']);
  }
}

class Pregunta {
  final int preguntaId;
  final String enunciado;
  final List<OpcionPregunta> opciones;

  Pregunta({required this.preguntaId, required this.enunciado, required this.opciones});

  factory Pregunta.fromJson(Map<String, dynamic> json) {
    return Pregunta(
      preguntaId: json['preguntaId'],
      enunciado: json['enunciado'],
      opciones: (json['opciones'] as List).map((o) => OpcionPregunta.fromJson(o)).toList(),
    );
  }
}

class ResultadoRespuesta {
  final bool esCorrecta;
  final int puntosOtorgados;
  final int monedasOtorgadas;

  ResultadoRespuesta({
    required this.esCorrecta,
    required this.puntosOtorgados,
    required this.monedasOtorgadas,
  });

  factory ResultadoRespuesta.fromJson(Map<String, dynamic> json) {
    return ResultadoRespuesta(
      esCorrecta: json['esCorrecta'],
      puntosOtorgados: json['puntosOtorgados'],
      monedasOtorgadas: json['monedasOtorgadas'],
    );
  }
}