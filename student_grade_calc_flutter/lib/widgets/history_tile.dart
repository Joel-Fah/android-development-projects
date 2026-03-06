import 'package:flutter/material.dart';
import '../models/grade_session.dart';
import '../theme/app_theme.dart';

/// List tile for one past session in the History page.
///
/// Shows: file name, formatted date, stats line, chevron icon.
/// [onTap]: opens a detail view for this session.
/// [onDelete]: removes this session from history.
class HistoryTile extends StatelessWidget {
  final GradeSession session;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const HistoryTile({
    super.key,
    required this.session,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            // Left side: file info and stats
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(session.fileName, style: AppTextStyles.heading()),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _formatDate(session.processedAt),
                    style: AppTextStyles.caption(),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${session.totalStudents} students · '
                    '${session.passCount} passed · '
                    '${session.failCount} failed · '
                    'Avg: ${session.classAverage.toStringAsFixed(1)}',
                    style: AppTextStyles.caption(),
                  ),
                ],
              ),
            ),

            // Right side: delete button + chevron
            IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete_outline,
                color: AppColors.textHint,
                size: 20,
              ),
              tooltip: 'Delete session',
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }

  /// Formats a DateTime into a readable string like "Mar 6, 2026 · 14:32".
  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} · '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }
}
