import 'dart:convert';
import 'student.dart';

/// Represents one completed grading session — i.e. one Excel file processed.
/// Stored in the local SQLite database so it appears in the History page.
class GradeSession {
  /// Auto-incremented by SQLite. Null before first save.
  final int? id;

  /// The original Excel file name (without full path), e.g. "class_a.xlsx".
  final String fileName;

  /// When this session was processed (stored as ISO-8601 string in SQLite).
  final DateTime processedAt;

  /// Total number of student rows processed.
  final int totalStudents;

  /// Number of students with status == "PASS".
  final int passCount;

  /// Number of students with status == "FAIL".
  final int failCount;

  /// Arithmetic mean of all students' averages.
  final double classAverage;

  /// Full enriched student list — serialized as JSON in SQLite.
  final List<Student> students;

  /// Subject header names extracted from the Excel header row.
  final List<String> subjectHeaders;

  const GradeSession({
    this.id,
    required this.fileName,
    required this.processedAt,
    required this.totalStudents,
    required this.passCount,
    required this.failCount,
    required this.classAverage,
    required this.students,
    required this.subjectHeaders,
  });

  /// Converts to a Map suitable for SQLite insertion.
  /// Lists are JSON-encoded as strings because SQLite has no array type.
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'fileName': fileName,
      'processedAt': processedAt.toIso8601String(),
      'totalStudents': totalStudents,
      'passCount': passCount,
      'failCount': failCount,
      'classAverage': classAverage,
      'studentsJson': jsonEncode(students.map((s) => s.toMap()).toList()),
      'headersJson': jsonEncode(subjectHeaders),
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  /// Reconstructs a [GradeSession] from a SQLite row Map.
  factory GradeSession.fromMap(Map<String, dynamic> map) => GradeSession(
        id: map['id'] as int?,
        fileName: map['fileName'] as String,
        processedAt: DateTime.parse(map['processedAt'] as String),
        totalStudents: map['totalStudents'] as int,
        passCount: map['passCount'] as int,
        failCount: map['failCount'] as int,
        classAverage: (map['classAverage'] as num).toDouble(),
        students: (jsonDecode(map['studentsJson'] as String) as List)
            .map((e) => Student.fromMap(e as Map<String, dynamic>))
            .toList(),
        subjectHeaders: List<String>.from(
          jsonDecode(map['headersJson'] as String) as List,
        ),
      );
}
