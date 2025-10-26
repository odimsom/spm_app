import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';

class AppTextFieldStyle {
  static InputDecoration defaultInputDecoration({
    required String hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: AppColors.iconColor),
      filled: true,
      fillColor: AppColors.inputColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );
  }
}
