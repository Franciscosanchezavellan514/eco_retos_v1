import 'package:flutter/material.dart';
import '../models/muro.dart';
import '../services/muro_service.dart';
import '../theme/app_theme.dart';
import 'comentarios_screen.dart';

class MuroScreen extends StatefulWidget {
  const MuroScreen({super.key});

  @override
  State<MuroScreen> createState() => _MuroScreenState();
}

class _MuroScreenState extends State<MuroScreen> {
  final _muroService = MuroService();
  final _publicacionController = TextEditingController();

  List<Publicacion> _publicaciones = [];
  bool _cargando = true;
  bool _publicando = false;

  @override
  void initState() {
    super.initState();
    _cargarMuro();
  }

  Future<void> _cargarMuro() async {
    setState(() => _cargando = true);
    final publicaciones = await _muroService.listarMuro();
    setState(() {
      _publicaciones = publicaciones;
      _cargando = false;
    });
  }

  Future<void> _publicar() async {
    final texto = _publicacionController.text.trim();
    if (texto.isEmpty) return;

    setState(() => _publicando = true);
    await _muroService.crearPublicacion(texto);
    _publicacionController.clear();
    await _cargarMuro();
    setState(() => _publicando = false);
  }

  Future<void> _reaccionar(int publicacionId) async {
    await _muroService.toggleReaccion(publicacionId);
    _cargarMuro();
  }

  void _abrirComentarios(int publicacionId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ComentariosScreen(publicacionId: publicacionId)),
    ).then((_) => _cargarMuro());
  }

  String _tiempoTranscurrido(DateTime fecha) {
    final diferencia = DateTime.now().difference(fecha);
    if (diferencia.inMinutes < 60) return 'Hace ${diferencia.inMinutes} min';
    if (diferencia.inHours < 24) return 'Hace ${diferencia.inHours}h';
    return 'Hace ${diferencia.inDays}d';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Muro Eco'),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  controller: _publicacionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Comparte una acción ambiental que hayas realizado...',
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _publicando ? null : _publicar,
                    child: _publicando
                        ? const SizedBox(
                            height: 18, width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Publicar'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _cargando
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _cargarMuro,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _publicaciones.length,
                      itemBuilder: (context, index) {
                        final pub = _publicaciones[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.surfaceSoft, width: 1.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: AppColors.surfaceSoft,
                                    child: Icon(Icons.person, color: AppColors.primary, size: 20),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pub.nombreUsuario,
                                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                        ),
                                        Text(
                                          _tiempoTranscurrido(pub.fechaPublicacion),
                                          style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(pub.contenido),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => _reaccionar(pub.publicacionId),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.favorite_border, size: 20, color: AppColors.danger),
                                        const SizedBox(width: 4),
                                        Text('${pub.totalReacciones}'),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  GestureDetector(
                                    onTap: () => _abrirComentarios(pub.publicacionId),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.chat_bubble_outline, size: 18, color: AppColors.textMuted),
                                        const SizedBox(width: 4),
                                        Text('${pub.totalComentarios}'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}