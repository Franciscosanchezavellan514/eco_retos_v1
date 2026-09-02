import 'package:flutter/material.dart';
import '../models/reto.dart';
import '../services/reto_service.dart';
import '../theme/app_theme.dart';

class RetosScreen extends StatefulWidget {
  const RetosScreen({super.key});

  @override
  State<RetosScreen> createState() => _RetosScreenState();
}

class _RetosScreenState extends State<RetosScreen> {
  final _retoService = RetoService();

  List<Reto> _retos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarRetos();
  }

  Future<void> _cargarRetos() async {
    setState(() => _cargando = true);
    final retos = await _retoService.listarActivos();
    setState(() {
      _retos = retos;
      _cargando = false;
    });
  }

  Future<void> _completarReto(Reto reto) async {
    final mensaje = await _retoService.completar(reto.retoId);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje)),
      );
    }

    // Recargamos la lista después de intentar completar,
    // por si el estado del usuario cambió (aunque la lista de retos
    // activos en sí no cambia, esto prepara el patrón para cuando
    // filtremos "ya completados" más adelante)
    _cargarRetos();
  }

  Color _colorDificultad(String dificultad) {
    switch (dificultad) {
      case 'Facil':
        return AppColors.primary;
      case 'Medio':
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
        title: const Text('Retos Ambientales'),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _retos.isEmpty
              ? Center(
                  child: Text(
                    'No hay retos disponibles por ahora.',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _cargarRetos,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _retos.length,
                    itemBuilder: (context, index) {
                      final reto = _retos[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: AppColors.surfaceSoft, width: 1.5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      reto.titulo,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _colorDificultad(reto.dificultad).withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      reto.dificultad,
                                      style: TextStyle(
                                        color: _colorDificultad(reto.dificultad),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                reto.descripcion,
                                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: AppColors.warning, size: 18),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${reto.puntosRecompensa} pts',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () => _completarReto(reto),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    ),
                                    child: const Text('Completar', style: TextStyle(fontSize: 13)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}