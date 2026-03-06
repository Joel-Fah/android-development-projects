import 'dart:io';
import 'package:excel/excel.dart';

/// Generates a heavy sample input Excel file with 30 students and 8 subjects.
/// Covers all grade boundaries and edge cases.
void main() {
  final excel = Excel.createExcel();
  excel.rename('Sheet1', 'Students');
  final sheet = excel['Students'];

  // 8 subjects for a richer dataset
  final headers = [
    'StudentID',
    'Name',
    'Math',
    'Physics',
    'Chemistry',
    'Biology',
    'English',
    'History',
    'Geography',
    'Computer Science',
  ];

  sheet.appendRow(headers.map((h) => TextCellValue(h)).toList());

  // Each row: [ID, Name, scores...]
  // Designed to cover every grade boundary and edge case
  final students = <List<dynamic>>[
    // === Grade A (avg >= 80) ===
    ['S001', 'Alice Martin',       95, 92, 88, 90, 85, 91, 87, 93],   // High A
    ['S002', 'Benjamin Okafor',    80, 80, 80, 80, 80, 80, 80, 80],   // Exact boundary A (avg=80)
    ['S003', 'Charlotte Zhang',   100, 98, 95, 97, 100, 92, 96, 99],  // Near-perfect
    ['S004', 'Daniel Mbeki',       82, 78, 85, 90, 76, 88, 84, 81],   // Mixed but A avg

    // === Grade B+ (avg 70-79) ===
    ['S005', 'Eva Nguyen',         79, 79, 79, 79, 79, 79, 79, 79],   // Just below A (avg=79)
    ['S006', 'Fatima Al-Hassan',   75, 72, 68, 78, 70, 74, 71, 76],   // Mid B+ range
    ['S007', 'Gabriel Santos',     70, 70, 70, 70, 70, 70, 70, 70],   // Exact boundary B+ (avg=70)
    ['S008', 'Hannah Kowalski',    85, 65, 72, 78, 60, 75, 80, 69],   // Wide spread, B+ avg

    // === Grade B (avg 60-69) ===
    ['S009', 'Ibrahim Diallo',     69, 69, 69, 69, 69, 69, 69, 69],   // Just below B+ (avg=69)
    ['S010', 'Julia Andersson',    65, 62, 68, 60, 64, 67, 63, 61],   // Mid B range
    ['S011', 'Kevin Tanaka',       60, 60, 60, 60, 60, 60, 60, 60],   // Exact boundary B (avg=60)
    ['S012', 'Lina Petrova',       55, 70, 65, 58, 72, 60, 63, 57],   // Wide spread, B avg

    // === Grade C+ (avg 55-59) ===
    ['S013', 'Mohammed El-Amin',   59, 59, 59, 59, 59, 59, 59, 59],   // Just below B (avg=59)
    ['S014', 'Nadia Fernandez',    57, 55, 58, 56, 54, 59, 55, 56],   // Mid C+ range
    ['S015', 'Oscar Johansson',    55, 55, 55, 55, 55, 55, 55, 55],   // Exact boundary C+ (avg=55)

    // === Grade C (avg 50-54) ===
    ['S016', 'Priya Sharma',       54, 54, 54, 54, 54, 54, 54, 54],   // Just below C+ (avg=54)
    ['S017', 'Quentin Dubois',     52, 50, 53, 51, 50, 54, 52, 50],   // Mid C range
    ['S018', 'Rosa Morales',       50, 50, 50, 50, 50, 50, 50, 50],   // Exact boundary C (avg=50)

    // === Grade D+ (avg 45-49) ===
    ['S019', 'Samuel Osei',        49, 49, 49, 49, 49, 49, 49, 49],   // Just below C (avg=49)
    ['S020', 'Tanya Volkov',       47, 45, 48, 46, 49, 45, 47, 46],   // Mid D+ range
    ['S021', 'Umar Siddiqui',      45, 45, 45, 45, 45, 45, 45, 45],   // Exact boundary D+ (avg=45)

    // === Grade D (avg 40-44) — PASS threshold ===
    ['S022', 'Valentina Rossi',    44, 44, 44, 44, 44, 44, 44, 44],   // Just below D+ (avg=44)
    ['S023', 'William Brown',      42, 40, 43, 41, 40, 44, 42, 40],   // Mid D range
    ['S024', 'Xiao-Ming Chen',     40, 40, 40, 40, 40, 40, 40, 40],   // Exact boundary D (avg=40) — last PASS

    // === Grade F (avg < 40) — FAIL ===
    ['S025', 'Yuki Nakamura',      39, 39, 39, 39, 39, 39, 39, 39],   // Just below pass (avg=39)
    ['S026', 'Zara Mensah',        35, 30, 38, 32, 28, 37, 33, 31],   // Low F range
    ['S027', 'André Lefebvre',     20, 15, 25, 18, 22, 10, 19, 21],   // Very low
    ['S028', 'Beatrice Kimura',     5, 10,  8, 12,  3, 15,  7,  4],   // Near-zero
    ['S029', 'Carlos Hernandez',    0,  0,  0,  0,  0,  0,  0,  0],   // All zeros
    ['S030', 'Diana Okonkwo',       1,  2,  3,  1,  2,  3,  1,  2],   // Barely above zero

    // === Edge cases ===
    ['S031', 'Ethan McAllister',   100, 0, 100, 0, 100, 0, 100, 0],   // Extreme variance (avg=50 → C)
    ['S032', 'Fiona O\'Brien',      39, 41, 39, 41, 39, 41, 39, 41],  // Hovering around pass line (avg=40 → D)
    ['S033', 'George Papadopoulos', 79, 80, 79, 80, 79, 80, 79, 80],  // Hovering A/B+ line (avg=79.5 → B+)
    ['S034', 'Haruki Watanabe',    55, 54, 55, 54, 55, 54, 55, 54],   // Hovering C+/C line (avg=54.5 → C)
    ['S035', 'Ingrid Svenson',     45, 44, 45, 44, 45, 44, 45, 44],   // Hovering D+/D line (avg=44.5 → D)
  ];

  for (final student in students) {
    final row = <CellValue>[
      TextCellValue(student[0] as String),
      TextCellValue(student[1] as String),
      ...student.sublist(2).map((s) => DoubleCellValue((s as int).toDouble())),
    ];
    sheet.appendRow(row);
  }

  // Write file
  final bytes = excel.encode();
  if (bytes != null) {
    // Use the script's own location to resolve the project root
    final scriptDir = Platform.script.toFilePath();
    final projectRoot = Directory(scriptDir).parent.parent.parent.path;
    final outputPath = '$projectRoot/heavy_sample_input.xlsx';
    File(outputPath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes);
    print('Generated $outputPath with ${students.length} students and ${headers.length - 2} subjects.');
  }
}
