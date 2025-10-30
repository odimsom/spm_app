import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';
import 'package:spm/src/core/utils/tutorial_helper.dart'; // ✅ Agregar import
import 'package:spm/src/screens/auth/login/login_screen.dart';
import 'package:spm/src/screens/auth/register/register_screen.dart';
import 'package:spm/src/screens/tutorial/components/tutorial_page.dart';
import 'package:spm/src/screens/tutorial/components/tutorial_page_indicator.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  /// Marcar tutorial como visto y navegar a Login
  Future<void> _completeTutorial() async {
    await TutorialHelper.markTutorialAsSeen();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Botón para saltar el tutorial
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _completeTutorial, // ✅ Llamar al método
                  child: Text(
                    "Omitir",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  TutorialPage(
                    imagePath: 'assets/images/screen1.png',
                    title: 'Conoce a San Pedro de Macorís',
                    description:
                        'Una de las provincias con más valor histórico y patrimonio arquitectónico de la República Dominicana, San Pedro de Macorís, la dueña de los atardeceres más bellos de todo Quisqueya.',
                  ),

                  // Segunda página
                  TutorialPage(
                    imagePath: 'assets/images/screen2.png',
                    title: 'Playas y Ríos',
                    description:
                        'Visitar nuestras hermosas playas y ríos sería una experiencia única ya que son de las más hermosas del país.',
                  ),

                  TutorialPage(
                    imagePath: 'assets/images/screen3.png',
                    title: '¡Empecemos a disfrutar de San Pedro de Macorís!',
                    description:
                        'Descubre todo lo que esta hermosa ciudad tiene para ofrecer.',
                    buttons: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(200, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: _completeTutorial, // ✅ Marcar como visto
                        child: const Text(
                          "Iniciar sesión",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(200, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: () async {
                          await TutorialHelper.markTutorialAsSeen();
                          if (!mounted)
                            return; // ✅ Verificar mounted antes del context

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Crear cuenta",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Indicadores de página
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botón retroceder
                  if (_currentPage > 0)
                    SizedBox(
                      width: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          elevation: 2,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Icon(Icons.arrow_back_ios, size: 20),
                      ),
                    ),

                  // Indicadores
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TutorialPageIndicator(
                      currentPage: _currentPage,
                      totalPages: 3,
                    ),
                  ),

                  // Botón avanzar
                  if (_currentPage < 2)
                    SizedBox(
                      width: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          elevation: 2,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Icon(Icons.arrow_forward_ios, size: 20),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
