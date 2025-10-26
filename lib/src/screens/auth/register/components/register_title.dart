import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';

class RegisterTitle extends StatelessWidget {
  final String title;

  const RegisterTitle({super.key, this.title = "Crear cuenta"});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 30),
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
