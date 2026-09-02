import 'package:flutter/material.dart';
import '../models/usuario_perfil.dart';
import '../services/session_service.dart';
import '../services/usuario_service.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'retos_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _sessionService = SessionService();
  final _usuarioService = UsuarioService();

  UsuarioPerfil? _perfil;
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  Future<void> _cargarPerfil() async {
    final perfil = await _usuarioService.obtenerMiPerfil();

    setState(() {
      _cargando = false;
      if (perfil == null) {
        _error = 'No se pudo cargar tu perfil.';
      } else {
        _perfil = perfil;
      }
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

  void _irARetos() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RetosScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Eco-Retos'),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _cerrarSesion,
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Text(_error!, style: const TextStyle(color: AppColors.danger)),
                )
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: const BoxDecoration(
                              color: AppColors.surfaceSoft,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.eco, color: AppColors.primary, size: 26),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '¡Bienvenido, ${_perfil!.nombreUsuario}!',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  'UID: ${_perfil!.uid}',
                                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Explora',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: _irARetos,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.surfaceSoft, width: 1.5),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.recycling, color: AppColors.primary, size: 28),
                              const SizedBox(width: 14),
                              const Expanded(
                                child: Text(
                                  'Retos Ambientales',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: AppColors.textMuted),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}