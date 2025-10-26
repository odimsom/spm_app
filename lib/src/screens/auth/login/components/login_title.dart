import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';

class LoginTitle extends StatelessWidget {
  final String title;

  const LoginTitle({super.key, this.title = "Iniciar Sesión"});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80, bottom: 50),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 25,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
