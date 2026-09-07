import 'package:flutter/material.dart';
import '../models/planta.dart';
import '../services/jardin_service.dart';
import '../theme/app_theme.dart';

class TiendaScreen extends StatefulWidget {
  const TiendaScreen({super.key});

  @override
  State<TiendaScreen> createState() => _TiendaScreenState();
}

class _TiendaScreenState extends State<TiendaScreen> {
  final _jardinService = JardinService();

  List<Planta> _plantas = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarTienda();
  }

  Future<void> _cargarTienda() async {
    setState(() => _cargando = true);
    final plantas = await _jardinService.listarTienda();
    setState(() {
      _plantas = plantas;
      _cargando = false;
    });
  }

  Future<void> _comprar(Planta planta) async {
    final mensaje = await _jardinService.comprarPlanta(planta.plantaId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tienda de Plantas'),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _cargarTienda,
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.85,
                ),
                itemCount: _plantas.length,
                itemBuilder: (context, index) {
                  final planta = _plantas[index];
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.surfaceSoft, width: 1.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: AppColors.surfaceSoft,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.local_florist, color: AppColors.primary, size: 32),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          planta.nombre,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.monetization_on, color: AppColors.warning, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${planta.precioMonedas}',
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _comprar(planta),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            child: const Text('Comprar', style: TextStyle(fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}