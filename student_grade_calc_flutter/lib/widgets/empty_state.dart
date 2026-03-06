import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable empty state widget — icon + title + optional subtitle.
/// Used on the History page when there are no sessions yet,
/// or anywhere else a "nothing here" message is needed.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: AppColors.textHint),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: AppTextStyles.heading(color: AppColors.textSecondary),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle!,
              style: AppTextStyles.caption(),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
