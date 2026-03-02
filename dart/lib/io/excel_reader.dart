import 'dart:io';
import 'package:excel/excel.dart';

import '../models/student.dart';

/// Reads student data from an Excel (`.xlsx`) file.
///
/// The expected spreadsheet layout is:
///
/// | StudentID | Name | Subject1 | Subject2 | … |
/// |-----------|------|----------|----------|---|
///
/// Row 0 is treated as the header row and is skipped when reading data.
class ExcelReader {
  /// Path to the `.xlsx` file to read.
  final String filePath;

  /// Creates an [ExcelReader] that will read from [filePath].
  ExcelReader(this.filePath);

  /// Reads the first sheet of the Excel file and returns a list of [Student]
  /// objects populated with their ID, name, and raw scores.
  ///
  /// Computed fields (average, grade, GPA, status) are left at their defaults
  /// and should be filled in by [GradeCalculator].
  List<Student> read() {
    // Step 1 — Read the raw bytes of the file from disk
    final fileBytes = File(filePath).readAsBytesSync();

    // Step 2 — Decode the bytes into an Excel workbook object
    final excel = Excel.decodeBytes(fileBytes);

    // Step 3 — Grab the first (and usually only) sheet
    final sheetName = excel.tables.keys.first;
    final sheet = excel.tables[sheetName]!;

    // We'll collect all Student objects here
    final List<Student> students = [];

    // Step 4 — Iterate over the rows, skipping the header (index 0)
    for (var rowIndex = 1; rowIndex < sheet.maxRows; rowIndex++) {
      final row = sheet.rows[rowIndex];

      // Skip completely empty rows
      if (row.isEmpty || row[0] == null) continue;

      // Column 0 → Student ID (converted to String)
      final studentId = row[0]!.value.toString();

      // Column 1 → Student name
      final name = row[1]!.value.toString();

      // Columns 2+ → Subject scores (converted to double)
      final scores = <double>[];
      for (var col = 2; col < row.length; col++) {
        if (row[col] != null && row[col]!.value != null) {
          // Parse the cell value; it may be int or double in Excel
          scores.add(double.parse(row[col]!.value.toString()));
        }
      }

      // Step 5 — Create a Student with only the raw data
      students.add(Student(
        studentId: studentId,
        name: name,
        scores: scores,
      ));
    }

    return students;
  }

  /// Reads the header row and returns only the subject column names
  /// (i.e. everything after StudentID and Name).
  ///
  /// This is useful for [ExcelWriter] so it can reproduce the same subject
  /// headers in the output file.
  List<String> readSubjectHeaders() {
    // Read and decode the file (same as in read())
    final fileBytes = File(filePath).readAsBytesSync();
    final excel = Excel.decodeBytes(fileBytes);

    // Grab the first sheet
    final sheetName = excel.tables.keys.first;
    final sheet = excel.tables[sheetName]!;

    // The header row is row 0
    final headerRow = sheet.rows[0];

    // Extract column names starting from index 2 (skip StudentID, Name)
    final headers = <String>[];
    for (var col = 2; col < headerRow.length; col++) {
      if (headerRow[col] != null && headerRow[col]!.value != null) {
        headers.add(headerRow[col]!.value.toString());
      }
    }

    return headers;
  }
}
