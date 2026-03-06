/// Represents one student record.
///
/// A [Student] is first created with only [studentId], [name], and [scores].
/// After passing through [GradeCalculator], the computed fields
/// ([average], [grade], [gpa], [status]) are filled in via [copyWith].
class Student {
  /// Unique identifier — read from column 0 of the Excel row.
  final String studentId;

  /// Full name — read from column 1 of the Excel row.
  final String name;

  /// Raw numeric scores for each subject — read from columns 2 onwards.
  final List<double> scores;

  /// Arithmetic mean of [scores]. Computed by [GradeCalculator].
  final double average;

  /// Letter grade string — e.g. "A", "B+", "F". Computed by [GradeCalculator].
  final String grade;

  /// GPA value corresponding to [grade] — e.g. 4.0, 3.5. Computed by [GradeCalculator].
  final double gpa;

  /// "PASS" if [grade] is not "F", otherwise "FAIL".
  final String status;

  const Student({
    required this.studentId,
    required this.name,
    required this.scores,
    this.average = 0.0,
    this.grade = '',
    this.gpa = 0.0,
    this.status = '',
  });

  /// Returns a new [Student] with the specified fields replaced.
  /// This is how [GradeCalculator] returns enriched students without mutating state.
  Student copyWith({
    String? studentId,
    String? name,
    List<double>? scores,
    double? average,
    String? grade,
    double? gpa,
    String? status,
  }) {
    return Student(
      studentId: studentId ?? this.studentId,
      name: name ?? this.name,
      scores: scores ?? this.scores,
      average: average ?? this.average,
      grade: grade ?? this.grade,
      gpa: gpa ?? this.gpa,
      status: status ?? this.status,
    );
  }

  /// Converts this student to a JSON-serializable Map.
  /// Used when saving to SQLite (stored as a JSON string).
  Map<String, dynamic> toMap() => {
        'studentId': studentId,
        'name': name,
        'scores': scores,
        'average': average,
        'grade': grade,
        'gpa': gpa,
        'status': status,
      };

  /// Reconstructs a [Student] from a Map (e.g. parsed from a SQLite JSON column).
  factory Student.fromMap(Map<String, dynamic> map) => Student(
        studentId: map['studentId'] as String,
        name: map['name'] as String,
        scores: List<double>.from(map['scores'] as List),
        average: (map['average'] as num).toDouble(),
        grade: map['grade'] as String,
        gpa: (map['gpa'] as num).toDouble(),
        status: map['status'] as String,
      );

  @override
  String toString() =>
      'Student($studentId, $name, avg: $average, grade: $grade, $status)';
}
