import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';

class ForgotPasswordLink extends StatelessWidget {
  final Function()? onTap;

  const ForgotPasswordLink({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "¿Haz olvidado tu contraseña? ",
            style: TextStyle(color: AppColors.primary, fontSize: 15),
          ),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              "Ingresa aquí",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
