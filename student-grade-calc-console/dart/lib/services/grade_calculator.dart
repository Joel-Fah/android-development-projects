import '../models/student.dart';

/// Service responsible for computing grades, GPAs, and pass/fail status.
///
/// Uses the following grading scale:
///
/// | Grade | GPA | Min | Max |
/// |-------|-----|-----|-----|
/// | A     | 4.0 | 80  | 100 |
/// | B+    | 3.5 | 70  | 79  |
/// | B     | 3.0 | 60  | 69  |
/// | C+    | 2.5 | 55  | 59  |
/// | C     | 2.0 | 50  | 54  |
/// | D+    | 1.5 | 45  | 49  |
/// | D     | 1.0 | 40  | 44  |
/// | F     | 0.0 | 0   | 39  |
class GradeCalculator {
  // ---------------------------------------------------------------------------
  // Grading‑scale boundary constants (no magic numbers in logic)
  // ---------------------------------------------------------------------------

  /// Minimum average required for grade A.
  static const double _minA = 80;

  /// Minimum average required for grade B+.
  static const double _minBPlus = 70;

  /// Minimum average required for grade B.
  static const double _minB = 60;

  /// Minimum average required for grade C+.
  static const double _minCPlus = 55;

  /// Minimum average required for grade C.
  static const double _minC = 50;

  /// Minimum average required for grade D+.
  static const double _minDPlus = 45;

  /// Minimum average required for grade D (also the pass threshold).
  static const double _minD = 40;

  // ---------------------------------------------------------------------------
  // Public methods
  // ---------------------------------------------------------------------------

  /// Computes the arithmetic mean of [scores].
  ///
  /// Returns `0.0` if the list is empty to avoid division‑by‑zero.
  double computeAverage(List<double> scores) {
    if (scores.isEmpty) return 0.0;

    // Sum all scores and divide by the number of subjects
    final double total = scores.reduce((a, b) => a + b);
    return total / scores.length;
  }

  /// Returns the letter grade corresponding to the given [average].
  ///
  /// Uses a simple series of `if / else if` checks against the grading scale
  /// boundaries defined above.
  String assignGrade(double average) {
    if (average >= _minA) {
      return 'A';
    } else if (average >= _minBPlus) {
      return 'B+';
    } else if (average >= _minB) {
      return 'B';
    } else if (average >= _minCPlus) {
      return 'C+';
    } else if (average >= _minC) {
      return 'C';
    } else if (average >= _minDPlus) {
      return 'D+';
    } else if (average >= _minD) {
      return 'D';
    } else {
      return 'F';
    }
  }

  /// Returns the GPA value corresponding to the given [average].
  ///
  /// Mirrors the same boundary logic as [assignGrade].
  double assignGpa(double average) {
    if (average >= _minA) {
      return 4.0;
    } else if (average >= _minBPlus) {
      return 3.5;
    } else if (average >= _minB) {
      return 3.0;
    } else if (average >= _minCPlus) {
      return 2.5;
    } else if (average >= _minC) {
      return 2.0;
    } else if (average >= _minDPlus) {
      return 1.5;
    } else if (average >= _minD) {
      return 1.0;
    } else {
      return 0.0;
    }
  }

  /// Returns `"PASS"` when [grade] is D or above, `"FAIL"` when grade is `"F"`.
  String determineStatus(String grade) {
    return grade == 'F' ? 'FAIL' : 'PASS';
  }

  /// Fills in [Student.average], [Student.grade], [Student.gpa], and
  /// [Student.status] on the given [student] and returns it.
  Student calculate(Student student) {
    // Step 1 — compute the average of all subject scores
    student.average = computeAverage(student.scores);

    // Step 2 — determine the letter grade from the average
    student.grade = assignGrade(student.average);

    // Step 3 — determine the GPA from the average
    student.gpa = assignGpa(student.average);

    // Step 4 — determine pass/fail from the letter grade
    student.status = determineStatus(student.grade);

    return student;
  }

  /// Applies [calculate] to every student in [students] and returns the list.
  List<Student> calculateAll(List<Student> students) {
    return students.map((student) => calculate(student)).toList();
  }
}
