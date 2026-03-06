import 'package:flutter/material.dart';
import '../models/student.dart';
import '../theme/app_theme.dart';

/// Shows class-level statistics below the results table.
///
/// Displays total students, pass count, fail count, and class average
/// in a compact horizontal row of stat chips.
class StatSummaryRow extends StatelessWidget {
  final List<Student> students;

  const StatSummaryRow({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    final passCount = students.where((s) => s.status == 'PASS').length;
    final failCount = students.length - passCount;
    final avg = students.isEmpty
        ? 0.0
        : students.fold(0.0, (sum, s) => sum + s.average) / students.length;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatChip(
            icon: Icons.people_outline,
            value: '${students.length}',
            label: 'Students',
          ),
          _verticalDivider(),
          _StatChip(
            icon: Icons.check_circle_outline,
            value: '$passCount',
            label: 'Passed',
            valueColor: AppColors.success,
          ),
          _verticalDivider(),
          _StatChip(
            icon: Icons.cancel_outlined,
            value: '$failCount',
            label: 'Failed',
            valueColor: AppColors.danger,
          ),
          _verticalDivider(),
          _StatChip(
            icon: Icons.bar_chart_outlined,
            value: avg.toStringAsFixed(1),
            label: 'Class Avg',
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      height: 32,
      width: 1,
      color: AppColors.border,
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? valueColor;

  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.textHint),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style:
              AppTextStyles.heading(color: valueColor ?? AppColors.textPrimary),
        ),
        Text(label, style: AppTextStyles.caption()),
      ],
    );
  }
}
