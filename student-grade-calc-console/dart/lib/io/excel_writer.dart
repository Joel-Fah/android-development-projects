import 'dart:io';
import 'package:excel/excel.dart';

import '../models/student.dart';

/// Writes enriched student data (with grades) to a new Excel (`.xlsx`) file.
///
/// The output layout is:
///
/// | StudentID | Name | Subject1 | … | Average | Grade | GPA | Status |
/// |-----------|------|----------|---|---------|-------|-----|--------|
class ExcelWriter {
  /// Path where the output `.xlsx` file will be saved.
  final String outputPath;

  /// Creates an [ExcelWriter] that will save results to [outputPath].
  ExcelWriter(this.outputPath);

  /// Writes all [students] and their computed grades to a new Excel workbook.
  ///
  /// [subjectHeaders] provides the column names for the score columns
  /// (e.g. ["Math", "Science", "English", "History"]).
  void write(List<Student> students, List<String> subjectHeaders) {
    // Step 1 — Create a brand‑new Excel workbook
    final excel = Excel.createExcel();

    // Step 2 — Rename the default sheet to "Results"
    final defaultSheet = excel.getDefaultSheet()!;
    excel.rename(defaultSheet, 'Results');
    final sheet = excel['Results'];

    // Step 3 — Build and write the header row
    final headers = [
      'StudentID',
      'Name',
      ...subjectHeaders, // Dynamic subject columns
      'Average',
      'Grade',
      'GPA',
      'Status',
    ];

    // Write each header cell in row 0
    for (var col = 0; col < headers.length; col++) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0))
          .value = TextCellValue(headers[col]);
    }

    // Step 4 — Write one row per student
    for (var rowIndex = 0; rowIndex < students.length; rowIndex++) {
      final student = students[rowIndex];
      // Data rows start at row 1 (row 0 is the header)
      final excelRow = rowIndex + 1;

      var col = 0;

      // Column 0 — Student ID
      sheet
          .cell(CellIndex.indexByColumnRow(
              columnIndex: col++, rowIndex: excelRow))
          .value = TextCellValue(student.studentId);

      // Column 1 — Name
      sheet
          .cell(CellIndex.indexByColumnRow(
              columnIndex: col++, rowIndex: excelRow))
          .value = TextCellValue(student.name);

      // Columns 2..N — Individual subject scores
      for (final score in student.scores) {
        sheet
            .cell(CellIndex.indexByColumnRow(
                columnIndex: col++, rowIndex: excelRow))
            .value = DoubleCellValue(score);
      }

      // Average column
      sheet
          .cell(CellIndex.indexByColumnRow(
              columnIndex: col++, rowIndex: excelRow))
          .value = DoubleCellValue(student.average);

      // Grade column
      sheet
          .cell(CellIndex.indexByColumnRow(
              columnIndex: col++, rowIndex: excelRow))
          .value = TextCellValue(student.grade);

      // GPA column
      sheet
          .cell(CellIndex.indexByColumnRow(
              columnIndex: col++, rowIndex: excelRow))
          .value = DoubleCellValue(student.gpa);

      // Status column
      sheet
          .cell(CellIndex.indexByColumnRow(
              columnIndex: col++, rowIndex: excelRow))
          .value = TextCellValue(student.status);
    }

    // Step 5 — Encode the workbook to bytes and save to disk
    final fileBytes = excel.encode();
    if (fileBytes != null) {
      File(outputPath)
        ..createSync(recursive: true) // Ensure parent directories exist
        ..writeAsBytesSync(fileBytes);
    }
  }
}
