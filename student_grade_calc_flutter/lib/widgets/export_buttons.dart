import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Two side-by-side buttons: Download Excel and Download PDF.
///
/// [onExportExcel]: called when user taps Excel button
/// [onExportPdf]: called when user taps PDF button
class ExportButtons extends StatelessWidget {
  final VoidCallback onExportExcel;
  final VoidCallback onExportPdf;

  const ExportButtons({
    super.key,
    required this.onExportExcel,
    required this.onExportPdf,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onExportExcel,
            icon: const Icon(Icons.table_chart_outlined, size: 18),
            label: const Text('Download Excel'),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onExportPdf,
            icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
            label: const Text('Download PDF'),
          ),
        ),
      ],
    );
  }
}
