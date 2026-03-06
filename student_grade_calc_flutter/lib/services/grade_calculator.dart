import '../models/student.dart';

/// Stateless service that computes grades for a list of students.
///
/// All methods are pure functions — given the same input, they always
/// return the same output, and they never modify any external state.
/// This makes them very easy to test (see grade_calculator_test.dart).
class GradeCalculator {
  /// Returns the arithmetic mean of [scores].
  /// Returns 0.0 if [scores] is empty to avoid division by zero.
  double computeAverage(List<double> scores) {
    if (scores.isEmpty) return 0.0;
    // fold() starts at 0.0 and adds each score one by one
    final total = scores.fold(0.0, (sum, score) => sum + score);
    return total / scores.length;
  }

  /// Maps a numeric [average] to a letter grade string.
  ///
  /// Uses a simple if/else chain — intentionally kept readable.
  /// The grading scale used here:
  ///   A  (4.0) → 80–100
  ///   B+ (3.5) → 70–79
  ///   B  (3.0) → 60–69
  ///   C+ (2.5) → 55–59
  ///   C  (2.0) → 50–54
  ///   D+ (1.5) → 45–49
  ///   D  (1.0) → 40–44
  ///   F  (0.0) → 0–39
  String assignGrade(double average) {
    if (average >= 80) return 'A';
    if (average >= 70) return 'B+';
    if (average >= 60) return 'B';
    if (average >= 55) return 'C+';
    if (average >= 50) return 'C';
    if (average >= 45) return 'D+';
    if (average >= 40) return 'D';
    return 'F';
  }

  /// Returns the GPA value corresponding to a letter [grade].
  double assignGpa(String grade) {
    switch (grade) {
      case 'A':
        return 4.0;
      case 'B+':
        return 3.5;
      case 'B':
        return 3.0;
      case 'C+':
        return 2.5;
      case 'C':
        return 2.0;
      case 'D+':
        return 1.5;
      case 'D':
        return 1.0;
      default:
        return 0.0; // F
    }
  }

  /// Returns "PASS" if the student's [grade] is not "F", else "FAIL".
  String determineStatus(String grade) => grade == 'F' ? 'FAIL' : 'PASS';

  /// Enriches a single [student] with computed average, grade, GPA, and status.
  ///
  /// Uses [copyWith] — never mutates the original object.
  Student calculate(Student student) {
    final avg = computeAverage(student.scores);
    final grade = assignGrade(avg);
    return student.copyWith(
      average:
          double.parse(avg.toStringAsFixed(2)), // round to 2 decimal places
      grade: grade,
      gpa: assignGpa(grade),
      status: determineStatus(grade),
    );
  }

  /// Applies [calculate] to every student in [students].
  /// Returns a new list — the original is not modified.
  List<Student> calculateAll(List<Student> students) =>
      students.map(calculate).toList();

  /// Computes the class average from an already-enriched [students] list.
  double classAverage(List<Student> students) {
    if (students.isEmpty) return 0.0;
    return students.fold(0.0, (sum, s) => sum + s.average) / students.length;
  }
}
