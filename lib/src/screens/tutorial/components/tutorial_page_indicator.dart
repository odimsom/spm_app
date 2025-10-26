import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';

class TutorialPageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const TutorialPageIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: currentPage == index
                ? AppColors.primary
                : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
