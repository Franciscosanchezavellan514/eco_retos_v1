import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'inicio_screen.dart';
import 'retos_screen.dart';
import 'trivia_screen.dart';
import 'muro_screen.dart';
import 'perfil_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _indiceActual = 0;

  // IndexedStack mantiene el estado de cada pestaña vivo en memoria,
  // así que al cambiar de pestaña y volver, no se recarga desde cero
  // (por ejemplo, si estabas a la mitad de la trivia, no se pierde).
  final List<Widget> _pantallas = const [
    InicioScreen(),
    RetosScreen(),
    TriviaScreen(),
    MuroScreen(),
    PerfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _indiceActual,
        children: _pantallas,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceActual,
        onTap: (index) => setState(() => _indiceActual = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.recycling), label: 'Retos'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Trivia'),
          BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'Muro'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}