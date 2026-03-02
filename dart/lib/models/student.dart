/// Represents a student with their scores and computed grade information.
///
/// A [Student] holds the raw score data read from Excel, as well as
/// the computed fields (average, grade, GPA, status) that are filled in
/// by the [GradeCalculator] service.
class Student {
  /// Unique identifier for the student (e.g. "S001").
  final String studentId;

  /// Full name of the student (e.g. "Alice Martin").
  final String name;

  /// List of numeric scores for each subject.
  final List<double> scores;

  /// Arithmetic mean of all [scores]. Defaults to 0.0 until computed.
  double average;

  /// Letter grade derived from [average] (e.g. "A", "B+", "F").
  String grade;

  /// Grade Point Average on a 4.0 scale, derived from [average].
  double gpa;

  /// Pass/fail status: "PASS" if grade is D or above, "FAIL" otherwise.
  String status;

  /// Creates a new [Student] instance.
  ///
  /// [studentId] and [name] are required. [scores] defaults to an empty list.
  /// The computed fields [average], [grade], [gpa], and [status] have sensible
  /// defaults and are typically set by [GradeCalculator.calculate].
  Student({
    required this.studentId,
    required this.name,
    this.scores = const [],
    this.average = 0.0,
    this.grade = '',
    this.gpa = 0.0,
    this.status = '',
  });

  /// Returns a human-readable summary of the student's record.
  @override
  String toString() {
    return 'Student('
        'id: $studentId, '
        'name: $name, '
        'scores: $scores, '
        'average: ${average.toStringAsFixed(2)}, '
        'grade: $grade, '
        'gpa: ${gpa.toStringAsFixed(1)}, '
        'status: $status)';
  }
}
