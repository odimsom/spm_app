import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';

class ValidatedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? errorText;
  final bool obscureText;
  final IconData? prefixIcon;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;

  const ValidatedTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.errorText,
    this.obscureText = false,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError ? AppColors.error : Colors.grey.shade300,
              width: hasError ? 2 : 1,
            ),
            color: hasError
                ? AppColors.error.withValues(alpha: 0.05)
                : Colors.white,
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: TextStyle(
              fontSize: 16,
              color: hasError ? AppColors.error : Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: hasError
                    ? AppColors.error.withValues(alpha: 0.7)
                    : Colors.grey.shade500,
                fontSize: 16,
              ),
              prefixIcon: prefixIcon != null
                  ? Icon(
                      prefixIcon,
                      color: hasError ? AppColors.error : AppColors.primary,
                      size: 20,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: prefixIcon != null ? 12 : 16,
                vertical: 16,
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Icon(Icons.error_outline, size: 16, color: AppColors.error),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    errorText!,
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
