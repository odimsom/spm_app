import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';
import 'package:spm/src/core/utils/tutorial_helper.dart';
import 'package:spm/src/screens/tutorial/tutorial_screen.dart';
import 'package:spm/src/screens/auth/login/login_screen.dart';

/// Splash Screen con verificación de primera vez
/// Muestra logo + loading por 3 segundos
/// Si es primera vez → Tutorial
/// Si ya vio tutorial → Login directamente
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  /// Inicializa la app con delay de 3 segundos
  Future<void> _initializeApp() async {
    // Esperar 3 segundos para mostrar splash
    await Future.delayed(const Duration(seconds: 3));

    // Verificar si es primera vez
    if (mounted) {
      final hasSeenTutorial = await TutorialHelper.hasSeenTutorial();

      if (mounted) {
        if (hasSeenTutorial) {
          // Ya vio el tutorial, ir directo a Login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else {
          // Primera vez, mostrar tutorial
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TutorialScreen()),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Zona superior con logos centrados
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo principal (monument.svg)
                    SvgPicture.asset(
                      'assets/images/monument.svg',
                      height: 150,
                      colorFilter: ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Text logo
                    SvgPicture.asset(
                      'assets/images/text_logo.svg',
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        AppColors.shadowColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),

              // Zona inferior con loading
              Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 3,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Cargando...',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
