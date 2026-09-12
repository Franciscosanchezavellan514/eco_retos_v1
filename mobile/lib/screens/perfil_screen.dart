import 'package:flutter/material.dart';
import '../models/usuario_perfil.dart';
import '../services/session_service.dart';
import '../services/usuario_service.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'insignias_screen.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _usuarioService = UsuarioService();
  final _sessionService = SessionService();

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

  Future<void> _cerrarSesion() async {
    await _sessionService.cerrarSesion();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  void _irAInsignias() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InsigniasScreen()),
    );
  }

  Widget _estadisticaChica(IconData icono, String valor, String etiqueta, Color color) {
    return Column(
      children: [
        Icon(icono, color: color, size: 22),
        const SizedBox(height: 4),
        Text(valor, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        Text(etiqueta, style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_perfil == null) {
      return const Scaffold(body: Center(child: Text('No se pudo cargar tu perfil.')));
    }

    final perfil = _perfil!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _cargarPerfil,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: AppColors.primary, size: 48),
              ),
              const SizedBox(height: 12),
              Text(
                perfil.nombreUsuario,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              Text(perfil.email, style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
              const SizedBox(height: 4),
              Text('UID: ${perfil.uid}', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.surfaceSoft, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nivel ${perfil.nivel}',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                        if (perfil.nivel < 5)
                          Text(
                            'Nivel ${perfil.nivel + 1}',
                            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: perfil.progresoNivel,
                        minHeight: 10,
                        backgroundColor: AppColors.surfaceSoft,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      perfil.nivel >= 5
                          ? '¡Alcanzaste el nivel máximo!'
                          : 'Te faltan ${perfil.puntosParaSiguienteNivel} XP para subir de nivel.',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.surfaceSoft, width: 1.5),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.star, color: AppColors.warning, size: 24),
                          const SizedBox(height: 6),
                          Text('${perfil.puntos}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                          Text('XP', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.surfaceSoft, width: 1.5),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.monetization_on, color: AppColors.primary, size: 24),
                          const SizedBox(height: 6),
                          Text('${perfil.monedas}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                          Text('Monedas Eco', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.surfaceSoft, width: 1.5),
                ),
                child: Column(
                  children: [
                    const Text('Tu racha', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _estadisticaChica(Icons.local_fire_department, '${perfil.rachaActual}', 'Racha actual', AppColors.danger),
                        _estadisticaChica(Icons.emoji_events, '${perfil.mejorRacha}', 'Mejor racha', AppColors.warning),
                        _estadisticaChica(Icons.calendar_month, '${perfil.diasActivos}', 'Días activos', AppColors.primary),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              GestureDetector(
                onTap: _irAInsignias,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.surfaceSoft, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.emoji_events, color: AppColors.warning, size: 28),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Text('Mi Colección', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.textMuted),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _cerrarSesion,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.danger),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                  ),
                  child: const Text('Cerrar sesión', style: TextStyle(color: AppColors.danger)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}