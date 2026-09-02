import 'package:flutter/material.dart';
import '../models/usuario_perfil.dart';
import '../services/session_service.dart';
import '../services/usuario_service.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

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
      body: Center(
        child: _cargando
            ? const CircularProgressIndicator()
            : _error != null
                ? Text(_error!, style: const TextStyle(color: AppColors.danger))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.eco, color: AppColors.primary, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        '¡Bienvenido, ${_perfil!.nombreUsuario}!',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'UID: ${_perfil!.uid}',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                      Text(
                        _perfil!.email,
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    ],
                  ),
      ),
    );
  }
}