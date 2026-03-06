import 'dart:io';

import 'package:args/args.dart';

import 'package:student_grade_calculator/io/excel_reader.dart';
import 'package:student_grade_calculator/io/excel_writer.dart';
import 'package:student_grade_calculator/services/grade_calculator.dart';

/// Entry point for the Student Grade Calculator CLI.
///
/// Usage:
///   dart run bin/main.dart --input <path> --output <path>
///
/// Flags:
///   --input   Path to the input `.xlsx` file (required)
///   --output  Path for the output `.xlsx` file (required)
///   --help    Show usage information
void main(List<String> args) {
  // ── 1. Configure the argument parser ──────────────────────────────────────
  final parser = ArgParser()
    ..addOption('input', abbr: 'i', help: 'Path to the input .xlsx file')
    ..addOption('output', abbr: 'o', help: 'Path for the output .xlsx file')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show usage info');

  final ArgResults results;
  try {
    results = parser.parse(args);
  } catch (e) {
    print('Error: $e');
    print('Usage:\n${parser.usage}');
    exit(1);
  }

  // ── 2. Handle --help ──────────────────────────────────────────────────────
  if (results['help'] as bool) {
    print('Student Grade Calculator — Dart edition');
    print('');
    print('Usage:');
    print('  dart run bin/main.dart --input <file.xlsx> --output <file.xlsx>');
    print('');
    print(parser.usage);
    exit(0);
  }

  // ── 3. Validate required arguments ────────────────────────────────────────
  final inputPath = results['input'] as String?;
  final outputPath = results['output'] as String?;

  if (inputPath == null || outputPath == null) {
    print('Error: --input and --output are required.');
    print('Usage:\n${parser.usage}');
    exit(1);
  }

  // ── 4. Read students from the input Excel file ────────────────────────────
  final reader = ExcelReader(inputPath);
  final students = reader.read();
  final subjectHeaders = reader.readSubjectHeaders();

  // ── 5. Calculate grades for all students ──────────────────────────────────
  final calculator = GradeCalculator();
  final enrichedStudents = calculator.calculateAll(students);

  // ── 6. Write enriched data to the output Excel file ───────────────────────
  final writer = ExcelWriter(outputPath);
  writer.write(enrichedStudents, subjectHeaders);

  // ── 7. Print a summary to the console ─────────────────────────────────────
  final total = enrichedStudents.length;
  final passCount = enrichedStudents.where((s) => s.status == 'PASS').length;
  final failCount = total - passCount;

  print('=== Student Grade Calculator — Summary ===');
  print('Total students : $total');
  print('Passed         : $passCount');
  print('Failed         : $failCount');
  print('Output written : $outputPath');
}
