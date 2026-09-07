import 'package:flutter/material.dart';
import '../models/planta.dart';
import '../services/jardin_service.dart';
import '../theme/app_theme.dart';

class JardinScreen extends StatefulWidget {
  const JardinScreen({super.key});

  @override
  State<JardinScreen> createState() => _JardinScreenState();
}

class _JardinScreenState extends State<JardinScreen> {
  final _jardinService = JardinService();

  static const int _totalSlots = 12; // igual al límite definido en el backend

  List<JardinSlot> _slots = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarJardin();
  }

  Future<void> _cargarJardin() async {
    setState(() => _cargando = true);
    final slots = await _jardinService.verEstadoJardin();
    setState(() {
      _slots = slots;
      _cargando = false;
    });
  }

  JardinSlot? _slotEnPosicion(int numero) {
    for (final slot in _slots) {
      if (slot.numeroSlot == numero) return slot;
    }
    return null;
  }

  Future<void> _abrirSelectorDePlanta(int numeroSlot) async {
    final plantaId = await showDialog<int>(
      context: context,
      builder: (context) => _DialogoElegirPlantaId(numeroSlot: numeroSlot),
    );

    if (plantaId == null) return;

    final mensaje = await _jardinService.colocarPlanta(numeroSlot, plantaId);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
    }

    _cargarJardin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mi Jardín'),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _cargarJardin,
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: _totalSlots,
                itemBuilder: (context, index) {
                  final numeroSlot = index + 1;
                  final slot = _slotEnPosicion(numeroSlot);

                  return GestureDetector(
                    onTap: () => _abrirSelectorDePlanta(numeroSlot),
                    child: Container(
                      decoration: BoxDecoration(
                        color: slot != null ? AppColors.surfaceSoft : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: slot != null ? AppColors.primary : AppColors.surfaceSoft,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            slot != null ? Icons.local_florist : Icons.add,
                            color: slot != null ? AppColors.primary : AppColors.textMuted,
                            size: 28,
                          ),
                          if (slot != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              slot.nombrePlanta,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                          ],
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

/// Diálogo simple para elegir qué planta colocar en el slot elegido.
/// Muestra la tienda completa por ahora (más adelante se puede filtrar
/// para mostrar solo las plantas que el usuario ya compró).
class _DialogoElegirPlantaId extends StatefulWidget {
  final int numeroSlot;
  const _DialogoElegirPlantaId({required this.numeroSlot});

  @override
  State<_DialogoElegirPlantaId> createState() => _DialogoElegirPlantaIdState();
}

class _DialogoElegirPlantaIdState extends State<_DialogoElegirPlantaId> {
  final _jardinService = JardinService();
  List<Planta> _plantas = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final plantas = await _jardinService.listarTienda();
    setState(() {
      _plantas = plantas;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Elegir planta para el slot ${widget.numeroSlot}'),
      content: SizedBox(
        width: double.maxFinite,
        child: _cargando
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                shrinkWrap: true,
                itemCount: _plantas.length,
                itemBuilder: (context, index) {
                  final planta = _plantas[index];
                  return ListTile(
                    leading: const Icon(Icons.local_florist, color: AppColors.primary),
                    title: Text(planta.nombre),
                    onTap: () => Navigator.pop(context, planta.plantaId),
                  );
                },
              ),
      ),
    );
  }
}