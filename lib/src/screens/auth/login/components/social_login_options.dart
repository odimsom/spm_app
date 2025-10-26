import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';

class SocialLoginOptions extends StatelessWidget {
  final Function()? onFacebookTap;
  final Function()? onFingerprintTap;
  final Function()? onGoogleTap;

  const SocialLoginOptions({
    super.key,
    this.onFacebookTap,
    this.onFingerprintTap,
    this.onGoogleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "O continuar con:",
          style: TextStyle(color: AppColors.primary, fontSize: 18),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onFacebookTap,
                child: const Icon(Icons.facebook, color: Colors.blue, size: 50),
              ),
              GestureDetector(
                onTap: onFingerprintTap,
                child: Icon(
                  Icons.fingerprint,
                  size: 50,
                  color: AppColors.primary,
                ),
              ),
              GestureDetector(
                onTap: onGoogleTap,
                child: Image.asset(
                  'assets/icons/google.png',
                  width: 40,
                  height: 40,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
