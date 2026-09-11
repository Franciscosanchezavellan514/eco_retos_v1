import 'package:flutter/material.dart';
import '../models/usuario_perfil.dart';
import '../services/usuario_service.dart';
import '../theme/app_theme.dart';
import 'amigos_screen.dart';
import 'jardin_screen.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  final _usuarioService = UsuarioService();

  UsuarioPerfil? _perfil;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  Future<void> _cargarPerfil() async {
    setState(() => _cargando = true);
    final perfil = await _usuarioService.obtenerMiPerfil();
    setState(() {
      _perfil = perfil;
      _cargando = false;
    });
  }

  void _navegarA(Widget pantalla) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => pantalla))
        .then((_) => _cargarPerfil());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mi Eco Panel'),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _perfil == null
              ? const Center(child: Text('No se pudo cargar tu información.'))
              : RefreshIndicator(
                  onRefresh: _cargarPerfil,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '¡Hola, ${_perfil!.nombreUsuario}!',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Nivel ${_perfil!.nivel} · Racha de ${_perfil!.rachaActual} días',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                        ),
                        const SizedBox(height: 20),

                        // --- Resumen rápido de stats ---
                        Row(
                          children: [
                            Expanded(child: _statCard(Icons.star, '${_perfil!.puntos}', 'XP', AppColors.warning)),
                            const SizedBox(width: 10),
                            Expanded(child: _statCard(Icons.monetization_on, '${_perfil!.monedas}', 'Monedas', AppColors.primary)),
                            const SizedBox(width: 10),
                            Expanded(child: _statCard(Icons.local_fire_department, '${_perfil!.rachaActual}', 'Racha', AppColors.danger)),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // --- Tarjeta destacada: Jardín Virtual ---
                        GestureDetector(
                          onTap: () => _navegarA(const JardinScreen()),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.primary, AppColors.primaryDark],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.grass, color: Colors.white, size: 40),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Jardín Virtual',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Usa tus monedas para hacer crecer tu jardín',
                                        style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right, color: Colors.white),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // --- Amigos ---
                        GestureDetector(
                          onTap: () => _navegarA(const AmigosScreen()),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.surfaceSoft, width: 1.5),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.group, color: AppColors.primary, size: 28),
                                const SizedBox(width: 14),
                                const Expanded(
                                  child: Text('Amigos', style: TextStyle(fontWeight: FontWeight.w600)),
                                ),
                                const Icon(Icons.chevron_right, color: AppColors.textMuted),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _statCard(IconData icono, String valor, String etiqueta, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceSoft, width: 1.5),
      ),
      child: Column(
        children: [
          Icon(icono, color: color, size: 20),
          const SizedBox(height: 4),
          Text(valor, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          Text(etiqueta, style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
        ],
      ),
    );
  }
}