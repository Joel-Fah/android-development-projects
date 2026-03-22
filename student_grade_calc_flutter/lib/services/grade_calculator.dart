import '../models/student.dart';

/// Stateless service that computes grades for a list of students.
///
/// Refactored to use an interface (abstract class) and a factory method.
/// This allows for easy swapping of grading algorithms (e.g. weighted average)
/// in the future without changing the rest of the app.
abstract class GradeCalculator {
  /// Factory method returning the default implementation.
  factory GradeCalculator() => StandardGradeCalculator();

  double computeAverage(List<double> scores);
  String assignGrade(double average);
  double assignGpa(String grade);
  String determineStatus(String grade);
  Student calculate(Student student);
  List<Student> calculateAll(List<Student> students);
  double classAverage(List<Student> students);
}

/// Standard implementation of [GradeCalculator].
///
/// All methods are pure functions — given the same input, they always
/// return the same output, and they never modify any external state.
/// This makes them very easy to test (see grade_calculator_test.dart).
class StandardGradeCalculator implements GradeCalculator {
  @override
  double computeAverage(List<double> scores) {
    if (scores.isEmpty) return 0.0;
    // fold() starts at 0.0 and adds each score one by one
    final total = scores.fold(0.0, (sum, score) => sum + score);
    return total / scores.length;
  }

  @override
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

  @override
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

  @override
  String determineStatus(String grade) => grade == 'F' ? 'FAIL' : 'PASS';

  @override
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

  @override
  List<Student> calculateAll(List<Student> students) =>
      students.map(calculate).toList();

  @override
  double classAverage(List<Student> students) {
    if (students.isEmpty) return 0.0;
    return students.fold(0.0, (sum, s) => sum + s.average) / students.length;
  }
}
