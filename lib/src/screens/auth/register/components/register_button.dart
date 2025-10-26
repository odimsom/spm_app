import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';
import 'package:spm/src/core/utils/app_constants.dart';

class RegisterButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;

  const RegisterButton({
    super.key,
    required this.onPressed,
    this.text = "Crear cuenta",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppResponsive.getResponsivePadding(
        context,
      ).copyWith(top: AppConstants.spacingLg, bottom: AppConstants.spacingLg),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: AppConstants.buttonMinWidth * 2,
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: SizedBox(
          height: AppConstants.buttonHeightLg,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
            ),
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
