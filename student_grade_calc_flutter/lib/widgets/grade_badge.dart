import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A small rounded chip that displays a letter grade (e.g. "A", "B+").
/// Always uses AppColors.badgeBg and AppColors.badgeFg.
class GradeBadge extends StatelessWidget {
  final String grade;

  const GradeBadge({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.badgeBg,
        borderRadius: BorderRadius.circular(AppRadius.badge),
      ),
      child: Text(
        grade,
        style: AppTextStyles.label(color: AppColors.badgeFg),
      ),
    );
  }
}
