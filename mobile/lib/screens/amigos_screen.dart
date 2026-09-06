import 'package:flutter/material.dart';
import '../models/amigo.dart';
import '../services/amistad_service.dart';
import '../theme/app_theme.dart';

class AmigosScreen extends StatefulWidget {
  const AmigosScreen({super.key});

  @override
  State<AmigosScreen> createState() => _AmigosScreenState();
}

class _AmigosScreenState extends State<AmigosScreen> {
  final _amistadService = AmistadService();
  final _uidController = TextEditingController();

  List<Amigo> _amigos = [];
  bool _cargando = true;
  bool _enviandoSolicitud = false;

  @override
  void initState() {
    super.initState();
    _cargarAmigos();
  }

  Future<void> _cargarAmigos() async {
    setState(() => _cargando = true);
    final amigos = await _amistadService.listarAmigos();
    setState(() {
      _amigos = amigos;
      _cargando = false;
    });
  }

  Future<void> _enviarSolicitud() async {
    final uid = _uidController.text.trim();
    if (uid.isEmpty) return;

    setState(() => _enviandoSolicitud = true);
    final mensaje = await _amistadService.enviarSolicitud(uid);
    setState(() => _enviandoSolicitud = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje)),
      );
    }

    _uidController.clear();
  }

  @override
  void dispose() {
    _uidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Amigos'),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _uidController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'UID de tu amigo',
                      prefixIcon: Icon(Icons.person_search, color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _enviandoSolicitud ? null : _enviarSolicitud,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                    ),
                    child: _enviandoSolicitud
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Mis amigos (${_amigos.length})',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _cargando
                ? const Center(child: CircularProgressIndicator())
                : _amigos.isEmpty
                    ? Center(
                        child: Text(
                          'Aún no tienes amigos agregados.\nUsa el UID de alguien para empezar.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _cargarAmigos,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _amigos.length,
                          itemBuilder: (context, index) {
                            final amigo = _amigos[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: BorderSide(color: AppColors.surfaceSoft, width: 1.5),
                              ),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: AppColors.surfaceSoft,
                                  child: Icon(Icons.person, color: AppColors.primary),
                                ),
                                title: Text(
                                  amigo.nombreUsuario,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text('UID: ${amigo.uid}'),
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