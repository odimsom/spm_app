import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';
import 'package:spm/src/screens/tutorial/components/tutorial_page.dart';

class TutorialScreen3 extends StatelessWidget {
  final VoidCallback? onLoginPressed;
  final VoidCallback? onRegisterPressed;

  const TutorialScreen3({
    super.key,
    this.onLoginPressed,
    this.onRegisterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TutorialPage(
      imagePath: 'assets/images/screen3.png',
      title: '¡Empecemos a disfrutar de San Pedro de Macorís!',
      description:
          'Descubre todo lo que esta hermosa ciudad tiene para ofrecer.',
      buttons: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(280, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          onPressed: onLoginPressed,
          child: const Text("Iniciar sesión", style: TextStyle(fontSize: 18)),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.white,
            minimumSize: const Size(280, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          onPressed: onRegisterPressed,
          child: const Text("Crear cuenta", style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}
