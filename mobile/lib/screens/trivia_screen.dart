import 'package:flutter/material.dart';
import '../models/trivia.dart';
import '../services/trivia_service.dart';
import '../theme/app_theme.dart';
import 'trivia_preguntas_screen.dart';

class TriviaScreen extends StatefulWidget {
  const TriviaScreen({super.key});

  @override
  State<TriviaScreen> createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen> {
  final _triviaService = TriviaService();

  List<CategoriaTrivia> _categorias = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
  }

  Future<void> _cargarCategorias() async {
    setState(() => _cargando = true);
    final categorias = await _triviaService.listarCategorias();
    setState(() {
      _categorias = categorias;
      _cargando = false;
    });
  }

  Color _colorDificultad(String dificultad) {
    switch (dificultad) {
      case 'Facil':
        return AppColors.primary;
      case 'Intermedia':
        return AppColors.warning;
      case 'Dificil':
        return AppColors.danger;
      default:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Trivia Eco'),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _categorias.isEmpty
              ? Center(
                  child: Text(
                    'No hay categorías de trivia disponibles.',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _cargarCategorias,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _categorias.length,
                    itemBuilder: (context, index) {
                      final categoria = _categorias[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: AppColors.surfaceSoft, width: 1.5),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(14),
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: _colorDificultad(categoria.dificultad).withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.quiz, color: _colorDificultad(categoria.dificultad)),
                          ),
                          title: Text(
                            categoria.nombre,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text('Grupo ${categoria.grupo} · ${categoria.dificultad}'),
                          trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TriviaPreguntasScreen(categoria: categoria),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}