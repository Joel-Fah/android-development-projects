import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/student.dart';

/// Generates a PDF grade report using the `pdf` package (dart_pdf).
/// The resulting bytes can be saved to disk or printed via the `printing` package.
class PdfService {
  /// Builds a PDF document and returns its raw bytes.
  ///
  /// The PDF contains:
  ///   - A title: "Grade Report — [sessionLabel]"
  ///   - A generation timestamp
  ///   - A full data table with one row per student
  ///   - PASS rows highlighted in light green, FAIL rows in light red
  Future<Uint8List> generateReport({
    required List<Student> students,
    required List<String> subjectHeaders,
    required String sessionLabel,
  }) async {
    final pdf = pw.Document();

    // Column headers for the PDF table
    final columns = [
      'ID',
      'Name',
      ...subjectHeaders,
      'Avg',
      'Grade',
      'GPA',
      'Status'
    ];

    pdf.addPage(
      pw.MultiPage(
        // MultiPage handles content that spans multiple pages automatically
        pageFormat: PdfPageFormat.a4.landscape,
        // landscape fits wide tables better
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          // ── Title ─────────────────────────────────────────────────────────
          pw.Text(
            'Grade Report — $sessionLabel',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Generated on ${DateTime.now().toLocal().toString().substring(0, 16)}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
          pw.SizedBox(height: 16),

          // ── Data table ────────────────────────────────────────────────────
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            columnWidths: {
              0: const pw.FixedColumnWidth(40),
              1: const pw.FlexColumnWidth(2),
              for (int i = 2; i < columns.length; i++)
                i: const pw.FlexColumnWidth(1),
            },
            children: [
              // Header row
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: columns
                    .map((col) => pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 6, vertical: 4),
                          child: pw.Text(col,
                              style: pw.TextStyle(
                                  fontSize: 9, fontWeight: pw.FontWeight.bold)),
                        ))
                    .toList(),
              ),
              // Data rows
              for (final s in students)
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: s.status == 'PASS'
                        ? const PdfColor.fromInt(0xFFD8F3DC)
                        : const PdfColor.fromInt(0xFFFFE8E8),
                  ),
                  children: [
                    _cell(s.studentId),
                    _cell(s.name),
                    ...s.scores.map((score) => _cell(score.toStringAsFixed(0))),
                    _cell(s.average.toStringAsFixed(2)),
                    _cell(s.grade),
                    _cell(s.gpa.toStringAsFixed(1)),
                    _cell(s.status),
                  ],
                ),
            ],
          ),

          // ── Summary footer ────────────────────────────────────────────────
          pw.SizedBox(height: 12),
          pw.Text(
            'Total: ${students.length} students | '
            'Pass: ${students.where((s) => s.status == 'PASS').length} | '
            'Fail: ${students.where((s) => s.status == 'FAIL').length}',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  /// Helper: wraps text in a padded table cell with consistent font size.
  pw.Widget _cell(String text) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: pw.Text(text, style: const pw.TextStyle(fontSize: 9)),
      );
}
