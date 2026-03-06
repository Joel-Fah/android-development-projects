import 'package:flutter/material.dart';
import '../models/student.dart';
import '../theme/app_theme.dart';
import 'grade_badge.dart';
import 'stat_summary_row.dart';

/// Scrollable data table showing one row per student.
///
/// Columns: #, StudentID, Name, [subjects...], Average, Grade, GPA, Status
///
/// [students]: enriched list from GradeCalculator
/// [subjectHeaders]: column names for the subject scores
class ResultsTable extends StatelessWidget {
  final List<Student> students;
  final List<String> subjectHeaders;

  const ResultsTable({
    super.key,
    required this.students,
    required this.subjectHeaders,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // The table itself, wrapped in a card with horizontal scroll
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(AppColors.surface),
              dataRowMinHeight: 40,
              dataRowMaxHeight: 48,
              columnSpacing: AppSpacing.md,
              horizontalMargin: AppSpacing.md,
              headingTextStyle: AppTextStyles.label(),
              columns: [
                const DataColumn(label: Text('#')),
                const DataColumn(label: Text('ID')),
                const DataColumn(label: Text('Name')),
                ...subjectHeaders.map((h) => DataColumn(label: Text(h))),
                const DataColumn(label: Text('Average'), numeric: true),
                const DataColumn(label: Text('Grade')),
                const DataColumn(label: Text('GPA'), numeric: true),
                const DataColumn(label: Text('Status')),
              ],
              rows: List.generate(students.length, (i) {
                final s = students[i];
                // Alternate row background for readability
                final rowColor =
                    i.isEven ? AppColors.background : AppColors.surfaceDim;

                return DataRow(
                  color: WidgetStateProperty.all(rowColor),
                  cells: [
                    DataCell(Text('${i + 1}', style: AppTextStyles.body())),
                    DataCell(Text(s.studentId, style: AppTextStyles.body())),
                    DataCell(Text(s.name, style: AppTextStyles.body())),
                    ...s.scores.map((score) => DataCell(Text(
                        score.toStringAsFixed(0),
                        style: AppTextStyles.body()))),
                    DataCell(Text(s.average.toStringAsFixed(2),
                        style: AppTextStyles.label())),
                    DataCell(GradeBadge(grade: s.grade)),
                    DataCell(Text(s.gpa.toStringAsFixed(1),
                        style: AppTextStyles.body())),
                    DataCell(_statusText(s.status)),
                  ],
                );
              }),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // Summary stats below the table
        StatSummaryRow(students: students),
      ],
    );
  }

  /// Returns a colored text widget for PASS/FAIL status.
  Widget _statusText(String status) {
    final isPassed = status == 'PASS';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isPassed ? AppColors.successBg : AppColors.dangerBg,
        borderRadius: BorderRadius.circular(AppRadius.badge),
      ),
      child: Text(
        status,
        style: AppTextStyles.label(
          color: isPassed ? AppColors.success : AppColors.danger,
        ),
      ),
    );
  }
}
