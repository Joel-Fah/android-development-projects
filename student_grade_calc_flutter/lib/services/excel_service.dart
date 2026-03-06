import 'dart:io';
import 'package:excel/excel.dart';
import '../models/student.dart';

/// Handles all Excel file operations: reading student data and writing grade reports.
class ExcelService {
  /// Reads an .xlsx file at [filePath] and returns a record containing:
  /// - [students]: list of Student objects (scores populated, grades not yet computed)
  /// - [headers]: list of subject column names extracted from the header row
  ///
  /// Assumes row 0 is the header row.
  /// Column 0 = StudentID, Column 1 = Name, columns 2+ = subject scores.
  Future<({List<Student> students, List<String> headers})> readFile(
    String filePath,
  ) async {
    // Read the raw file bytes from disk
    final bytes = File(filePath).readAsBytesSync();

    // Decode the bytes as an Excel workbook
    final excel = Excel.decodeBytes(bytes);

    // Use the first sheet (index 0), whatever its name
    final sheet = excel.tables.values.first;
    final rows = sheet.rows;

    if (rows.isEmpty) {
      throw Exception('The Excel file is empty.');
    }

    // --- Extract subject headers from the header row ---
    // Row 0: [StudentID, Name, Math, Science, English, ...]
    // We want only columns 2 onwards as subject names
    final headerRow = rows[0];
    final subjectHeaders = headerRow
        .skip(2) // skip StudentID and Name
        .map((cell) => cell?.value?.toString() ?? 'Subject')
        .toList();

    // --- Parse each data row into a Student ---
    final students = <Student>[];
    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];

      // Skip completely empty rows
      if (row.every((cell) => cell == null || cell.value == null)) continue;

      final studentId = row[0]?.value?.toString() ?? '';
      final name = row[1]?.value?.toString() ?? '';

      // Parse scores from columns 2 onwards — default to 0.0 if missing
      final scores = <double>[];
      for (int j = 2; j < row.length; j++) {
        final raw = row[j]?.value;
        scores.add(double.tryParse(raw?.toString() ?? '') ?? 0.0);
      }

      students.add(Student(
        studentId: studentId,
        name: name,
        scores: scores,
      ));
    }

    return (students: students, headers: subjectHeaders);
  }

  /// Writes an enriched [students] list to a new .xlsx file at [outputPath].
  ///
  /// Output columns: StudentID, Name, [subjects...], Average, Grade, GPA, Status
  Future<void> writeFile(
    String outputPath,
    List<Student> students,
    List<String> subjectHeaders,
  ) async {
    // Create a new blank workbook
    final excel = Excel.createExcel();

    // Get the default sheet ("Sheet1")
    final sheet = excel['Sheet1'];

    // --- Build and write the header row ---
    final headers = [
      'StudentID',
      'Name',
      ...subjectHeaders,
      'Average',
      'Grade',
      'GPA',
      'Status',
    ];
    for (int col = 0; col < headers.length; col++) {
      // CellIndex.indexByColumnRow is 0-based
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0))
          .value = TextCellValue(headers[col]);
    }

    // --- Write one row per student ---
    for (int i = 0; i < students.length; i++) {
      final s = students[i];
      final rowIndex = i + 1; // +1 because row 0 is the header

      // Fixed columns
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
          .value = TextCellValue(s.studentId);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
          .value = TextCellValue(s.name);

      // Subject scores
      for (int j = 0; j < s.scores.length; j++) {
        sheet
            .cell(CellIndex.indexByColumnRow(
                columnIndex: 2 + j, rowIndex: rowIndex))
            .value = DoubleCellValue(s.scores[j]);
      }

      // Computed columns — placed after all subject columns
      final offset = 2 + s.scores.length;
      sheet
          .cell(CellIndex.indexByColumnRow(
              columnIndex: offset, rowIndex: rowIndex))
          .value = DoubleCellValue(s.average);
      sheet
          .cell(CellIndex.indexByColumnRow(
              columnIndex: offset + 1, rowIndex: rowIndex))
          .value = TextCellValue(s.grade);
      sheet
          .cell(CellIndex.indexByColumnRow(
              columnIndex: offset + 2, rowIndex: rowIndex))
          .value = DoubleCellValue(s.gpa);
      sheet
          .cell(CellIndex.indexByColumnRow(
              columnIndex: offset + 3, rowIndex: rowIndex))
          .value = TextCellValue(s.status);
    }

    // Encode the workbook to bytes and save to disk
    final fileBytes = excel.encode();
    if (fileBytes == null) throw Exception('Failed to encode Excel file.');
    await File(outputPath).writeAsBytes(fileBytes);
  }
}
