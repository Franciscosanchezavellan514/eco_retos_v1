import 'package:flutter/material.dart';
import '../models/trivia.dart';
import '../services/trivia_service.dart';
import '../theme/app_theme.dart';

class TriviaPreguntasScreen extends StatefulWidget {
  final CategoriaTrivia categoria;
  const TriviaPreguntasScreen({super.key, required this.categoria});

  @override
  State<TriviaPreguntasScreen> createState() => _TriviaPreguntasScreenState();
}

class _TriviaPreguntasScreenState extends State<TriviaPreguntasScreen> {
  final _triviaService = TriviaService();

  List<Pregunta> _preguntas = [];
  int _indiceActual = 0;
  bool _cargando = true;
  bool _respondiendo = false;
  int? _opcionSeleccionada;
  ResultadoRespuesta? _ultimoResultado;

  @override
  void initState() {
    super.initState();
    _cargarPreguntas();
  }

  Future<void> _cargarPreguntas() async {
    final preguntas = await _triviaService.listarPreguntas(widget.categoria.categoriaId);
    setState(() {
      _preguntas = preguntas;
      _cargando = false;
    });
  }

  Future<void> _responder(int opcionId) async {
    if (_respondiendo) return;

    setState(() {
      _respondiendo = true;
      _opcionSeleccionada = opcionId;
    });

    final pregunta = _preguntas[_indiceActual];
    final resultado = await _triviaService.responder(
      pregunta.preguntaId,
      opcionId,
      widget.categoria.categoriaId,
    );

    setState(() => _ultimoResultado = resultado);
  }

  void _siguientePregunta() {
    if (_indiceActual < _preguntas.length - 1) {
      setState(() {
        _indiceActual++;
        _opcionSeleccionada = null;
        _ultimoResultado = null;
        _respondiendo = false;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_preguntas.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.categoria.nombre)),
        body: const Center(child: Text('No hay preguntas en esta categoría.')),
      );
    }

    final pregunta = _preguntas[_indiceActual];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('${widget.categoria.nombre} · ${_indiceActual + 1}/${_preguntas.length}'),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              pregunta.enunciado,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            ...pregunta.opciones.map((opcion) {
              final esSeleccionada = _opcionSeleccionada == opcion.opcionId;
              Color colorBorde = AppColors.surfaceSoft;
              Color colorFondo = Colors.white;

              if (_ultimoResultado != null && esSeleccionada) {
                colorBorde = _ultimoResultado!.esCorrecta ? AppColors.primary : AppColors.danger;
                colorFondo = _ultimoResultado!.esCorrecta
                    ? AppColors.primary.withValues(alpha: 0.08)
                    : AppColors.danger.withValues(alpha: 0.08);
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () => _responder(opcion.opcionId),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorFondo,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: colorBorde, width: 1.5),
                    ),
                    child: Text(opcion.texto),
                  ),
                ),
              );
            }),
            const Spacer(),
            if (_ultimoResultado != null) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _ultimoResultado!.esCorrecta
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.danger.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  _ultimoResultado!.esCorrecta
                      ? (_ultimoResultado!.puntosOtorgados > 0
                          ? '¡Correcto! +${_ultimoResultado!.puntosOtorgados} pts, +${_ultimoResultado!.monedasOtorgadas} moneda(s)'
                          : '¡Correcto! (ya no otorga recompensa, no es tu primer intento)')
                      : 'Incorrecto. La respuesta correcta era otra opción.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _ultimoResultado!.esCorrecta ? AppColors.primary : AppColors.danger,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _siguientePregunta,
                child: Text(_indiceActual < _preguntas.length - 1 ? 'Siguiente pregunta' : 'Terminar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}