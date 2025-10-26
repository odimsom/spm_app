import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';
import 'package:spm/src/core/utils/app_constants.dart';

class LoginLogo extends StatelessWidget {
  final double? width;
  final double? height;

  const LoginLogo({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    final logoSize = AppResponsive.getResponsiveValue(
      context: context,
      mobile: AppConstants.logoSizeMedium,
      tablet: AppConstants.logoSizeLarge,
      desktop: AppConstants.logoSizeLarge,
    );

    return Padding(
      padding: EdgeInsets.only(
        top: AppResponsive.getResponsiveValue(
          context: context,
          mobile: AppConstants.spacingXl * 2,
          tablet: AppConstants.spacingXl * 3,
        ),
      ),
      child: SizedBox(
        width: width ?? logoSize,
        height: height ?? logoSize,
        child: _buildLogoImage(),
      ),
    );
  }

  Widget _buildLogoImage() {
    try {
      return Padding(
        padding: EdgeInsets.only(bottom: AppConstants.spacingSm),
        child: SvgPicture.asset(
          "assets/images/monument.svg",
          colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
          fit: BoxFit.contain,
        ),
      );
    } catch (e) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: AppConstants.borderRadiusMd,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              size: AppConstants.iconSizeXl,
              color: AppColors.primary,
            ),
            SizedBox(height: AppConstants.spacingSm),
            Text(
              "Logo App",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
  }
}
