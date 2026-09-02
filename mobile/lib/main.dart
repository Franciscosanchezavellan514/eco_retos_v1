import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const EcoRetosApp());
}

class EcoRetosApp extends StatelessWidget {
  const EcoRetosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eco-Retos',
      theme: AppTheme.light,
      home: const LoginScreen(),
    );
  }
}