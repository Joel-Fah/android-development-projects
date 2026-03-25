import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Buttons to export/share data as Excel or PDF.
class ExportButtons extends StatelessWidget {
  final VoidCallback onExportExcel;
  final VoidCallback onExportPdf;
  final VoidCallback onShareExcel;
  final VoidCallback onSharePdf;

  const ExportButtons({
    super.key,
    required this.onExportExcel,
    required this.onExportPdf,
    required this.onShareExcel,
    required this.onSharePdf,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ExportRow(
          label: 'Excel Report',
          icon: Icons.table_chart_outlined,
          onSave: onExportExcel,
          onShare: onShareExcel,
        ),
        const SizedBox(height: AppSpacing.sm),
        _ExportRow(
          label: 'PDF Report',
          icon: Icons.picture_as_pdf_outlined,
          onSave: onExportPdf,
          onShare: onSharePdf,
        ),
      ],
    );
  }
}

class _ExportRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onSave;
  final VoidCallback onShare;

  const _ExportRow({
    required this.label,
    required this.icon,
    required this.onSave,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onSave,
            icon: Icon(icon, size: 18),
            label: Text('Save $label'),
            style: OutlinedButton.styleFrom(
              alignment: Alignment.centerLeft,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        IconButton.outlined(
          onPressed: onShare,
          icon: const Icon(Icons.share_outlined, size: 18),
          tooltip: 'Share $label',
        ),
      ],
    );
  }
}
