import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A dashed-border card that lets the user pick an Excel file.
///
/// Shows an upload icon, instruction text, and a "Browse" button.
/// Once a file is selected, shows the file name and a "Process" button.
///
/// Callbacks:
///   [onFilePicked]: called when user taps "Browse" to open the file picker
///   [onProcess]: called when user taps "Process File"
///   [selectedFileName]: if not null, shows the file name and Process button
///   [isProcessing]: if true, shows a loading indicator instead of the button
class FilePickerCard extends StatelessWidget {
  final String? selectedFileName;
  final bool isProcessing;
  final VoidCallback onFilePicked;
  final VoidCallback onProcess;

  const FilePickerCard({
    super.key,
    this.selectedFileName,
    this.isProcessing = false,
    required this.onFilePicked,
    required this.onProcess,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: AppColors.borderDash,
        radius: AppRadius.card,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.upload_file_outlined,
              size: 40,
              color: AppColors.textHint,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text('Select an Excel file', style: AppTextStyles.heading()),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Supported format: .xlsx',
              style: AppTextStyles.caption(),
            ),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: onFilePicked,
              child: const Text('Browse'),
            ),

            // Show selected file name and Process button when a file is picked
            if (selectedFileName != null) ...[
              const SizedBox(height: AppSpacing.lg),
              const Divider(color: AppColors.border),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.insert_drive_file_outlined,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text(
                      selectedFileName!,
                      style: AppTextStyles.body(color: AppColors.textSecondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isProcessing
                    ? Column(
                        key: const ValueKey('loader'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 28,
                            width: 28,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.accent,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Processing...',
                            style: AppTextStyles.caption(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      )
                    : ElevatedButton(
                        key: const ValueKey('button'),
                        onPressed: onProcess,
                        child: const Text('Process File'),
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Custom painter that draws a dashed rectangular border with rounded corners.
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  static const double _dashWidth = 6.0;
  static const double _dashGap = 4.0;
  static const double _strokeWidth = 1.5;

  _DashedBorderPainter({
    required this.color,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    // Convert RRect to a Path and extract metrics for dashing
    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final end = min(distance + _dashWidth, metric.length);
        final extractPath = metric.extractPath(distance, end);
        canvas.drawPath(extractPath, paint);
        distance += _dashWidth + _dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
