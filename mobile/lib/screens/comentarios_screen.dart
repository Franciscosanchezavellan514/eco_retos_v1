import 'package:flutter/material.dart';
import '../models/muro.dart';
import '../services/muro_service.dart';
import '../theme/app_theme.dart';

class ComentariosScreen extends StatefulWidget {
  final int publicacionId;
  const ComentariosScreen({super.key, required this.publicacionId});

  @override
  State<ComentariosScreen> createState() => _ComentariosScreenState();
}

class _ComentariosScreenState extends State<ComentariosScreen> {
  final _muroService = MuroService();
  final _comentarioController = TextEditingController();

  List<Comentario> _comentarios = [];
  bool _cargando = true;
  bool _enviando = false;

  @override
  void initState() {
    super.initState();
    _cargarComentarios();
  }

  Future<void> _cargarComentarios() async {
    setState(() => _cargando = true);
    final comentarios = await _muroService.listarComentarios(widget.publicacionId);
    setState(() {
      _comentarios = comentarios;
      _cargando = false;
    });
  }

  Future<void> _enviarComentario() async {
    final texto = _comentarioController.text.trim();
    if (texto.isEmpty) return;

    setState(() => _enviando = true);
    await _muroService.crearComentario(widget.publicacionId, texto);
    _comentarioController.clear();
    await _cargarComentarios();
    setState(() => _enviando = false);
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Comentarios'),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: _cargando
                ? const Center(child: CircularProgressIndicator())
                : _comentarios.isEmpty
                    ? Center(
                        child: Text(
                          'Sé el primero en comentar.',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _comentarios.length,
                        itemBuilder: (context, index) {
                          final comentario = _comentarios[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.surfaceSoft, width: 1.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comentario.nombreUsuario,
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                ),
                                const SizedBox(height: 4),
                                Text(comentario.contenido),
                              ],
                            ),
                          );
                        },
                      ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.surfaceSoft, width: 1.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _comentarioController,
                    decoration: const InputDecoration(hintText: 'Escribe un comentario...'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _enviando ? null : _enviarComentario,
                  icon: _enviando
                      ? const SizedBox(
                          height: 18, width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send, color: AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}