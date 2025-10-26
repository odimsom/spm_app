import 'package:flutter/material.dart';
import 'package:spm/src/core/utils/app_constants.dart';

class LoginButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;

  const LoginButton({
    super.key,
    required this.onPressed,
    this.text = "Iniciar sesión",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppResponsive.getResponsivePadding(
        context,
      ).copyWith(top: AppConstants.spacingXl, bottom: AppConstants.spacingXl),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: AppConstants.buttonMinWidth * 2,
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: SizedBox(
          height: AppConstants.buttonHeightLg,
          child: ElevatedButton(
            onPressed: onPressed,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
      ),
    );
  }
}
