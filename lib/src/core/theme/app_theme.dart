import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';
import 'package:spm/src/core/theme/text_styles/app_text_styles.dart';
import 'package:spm/src/core/utils/app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      // Color scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.scaffoldBackground,
        error: AppColors.error,
      ),

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.scaffoldBackground,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headingSmall,
        iconTheme: IconThemeData(
          color: AppColors.textSecondary,
          size: AppConstants.iconSizeMd,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.primary,
        selectedItemColor: AppColors.navigationActive,
        unselectedItemColor: AppColors.navigationInactive,
        type: BottomNavigationBarType.fixed,
        elevation: AppConstants.elevationMd,
        selectedIconTheme: const IconThemeData(size: AppConstants.iconSizeLg),
        unselectedIconTheme: const IconThemeData(size: AppConstants.iconSizeMd),
        selectedLabelStyle: AppTextStyles.navigation,
        unselectedLabelStyle: AppTextStyles.navigation,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textLight,
          elevation: AppConstants.elevationSm,
          minimumSize: const Size(
            AppConstants.buttonMinWidth,
            AppConstants.buttonHeightMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppConstants.borderRadiusXl,
          ),
          textStyle: AppTextStyles.buttonMedium,
          padding: AppConstants.paddingHorizontalLg,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.link,
          padding: AppConstants.paddingMd,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputColor,
        border: OutlineInputBorder(
          borderRadius: AppConstants.borderRadiusMd,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppConstants.borderRadiusMd,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppConstants.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppConstants.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        contentPadding: AppConstants.paddingMd,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: AppConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: AppConstants.borderRadiusMd,
        ),
        margin: AppConstants.paddingSm,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.iconColor,
        size: AppConstants.iconSizeMd,
      ),

      // Text Theme
      textTheme: const TextTheme(
        headlineLarge: AppTextStyles.headingLarge,
        headlineMedium: AppTextStyles.headingMedium,
        headlineSmall: AppTextStyles.headingSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.buttonLarge,
        labelMedium: AppTextStyles.buttonMedium,
        labelSmall: AppTextStyles.buttonSmall,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.iconColor,
        thickness: 1,
        space: AppConstants.spacingMd,
      ),

      // Scaffold Theme
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
    );
  }
}
