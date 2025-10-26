import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/app_theme.dart';
import 'package:spm/src/core/services/session_service.dart';
import 'package:spm/src/screens/tutorial/tutorial_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar la sesión
  await SessionService().initializeSession();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rutas SPM',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const TutorialScreen(),
    );
  }
}
