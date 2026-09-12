import 'package:flutter/material.dart';
import '../models/insignia.dart';
import '../services/insignia_service.dart';
import '../theme/app_theme.dart';

class InsigniasScreen extends StatefulWidget {
  const InsigniasScreen({super.key});

  @override
  State<InsigniasScreen> createState() => _InsigniasScreenState();
}

class _InsigniasScreenState extends State<InsigniasScreen> {
  final _insigniaService = InsigniaService();

  List<Insignia> _insignias = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarInsignias();
  }

  Future<void> _cargarInsignias() async {
    setState(() => _cargando = true);
    final insignias = await _insigniaService.listarMisInsignias();
    setState(() {
      _insignias = insignias;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mi Colección'),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _insignias.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.emoji_events_outlined, color: AppColors.textMuted, size: 56),
                        const SizedBox(height: 12),
                        Text(
                          'Todavía no tienes insignias.\nSigue completando retos y trivia para ganarlas.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _cargarInsignias,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: _insignias.length,
                    itemBuilder: (context, index) {
                      final insignia = _insignias[index];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.surfaceSoft, width: 1.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: const BoxDecoration(
                                color: AppColors.surfaceSoft,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.emoji_events, color: AppColors.warning, size: 30),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              insignia.nombre,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                            if (insignia.descripcion != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                insignia.descripcion!,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: AppColors.textMuted, fontSize: 10),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}