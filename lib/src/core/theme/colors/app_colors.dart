import 'package:flutter/material.dart';

class AppColors {
  // Colores principales de la aplicación
  static const Color primary = Color.fromARGB(255, 53, 122, 42);
  static const Color secondary = Color.fromARGB(255, 33, 46, 36);
  static const Color accent = Color.fromARGB(255, 179, 200, 123);

  // Color para navegación activa (rojo como solicitado)
  static const Color navigationActive = Color(0xFFE53E3E);
  static const Color navigationInactive = Colors.white;

  // Colores de íconos
  static const Color iconColor = Color.fromARGB(255, 217, 217, 217);
  static const Color iconActive = navigationActive;

  // Fondos
  static const Color background = Color.fromARGB(255, 235, 232, 189);
  static const Color backgroundSelected = Color.fromARGB(255, 250, 188, 5);
  static const Color scaffoldBackground = Colors.white;

  // Componentes
  static const Color inputColor = Color.fromARGB(255, 239, 239, 239);
  static const Color cardBackground = Colors.white;
  static const Color shadowColor = Colors.black;

  // Estados
  static const Color success = Color(0xFF38A169);
  static const Color error = Color(0xFFE53E3E);
  static const Color warning = Color(0xFFD69E2E);
  static const Color info = Color(0xFF3182CE);

  // Textos
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color.fromARGB(255, 53, 122, 42);
  static const Color textLight = Colors.white;
}
