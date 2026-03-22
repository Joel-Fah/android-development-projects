import 'package:flutter_test/flutter_test.dart';
import 'package:student_grade_calculator/services/grade_calculator.dart';

/// A "Strict" implementation of [GradeCalculator] for demonstration purposes.
/// This class exists solely to verify polymorphism and inheritance.
///
/// It extends [StandardGradeCalculator] to inherit the `computeAverage` and
/// `calculate` traversal logic, but overrides `assignGrade` to enforce
/// a stricter grading scale.
class StrictGradeCalculator extends StandardGradeCalculator {
  @override
  String assignGrade(double average) {
    // Stricter grading scale
    if (average >= 90) return 'A'; // Standard is 80
    if (average >= 80) return 'B'; // Standard is 70+ for B/B+
    if (average >= 70) return 'C';
    if (average >= 60) return 'D';
    return 'F';
  }

  @override
  double assignGpa(String grade) {
    // Simplified GPA
    switch (grade) {
      case 'A': return 4.0;
      case 'B': return 3.0;
      case 'C': return 2.0;
      case 'D': return 1.0;
      default: return 0.0;
    }
  }
}

void main() {
  group('GradeCalculator Polymorphism Verification', () {
    test('StandardGradeCalculator implements GradeCalculator interface', () {
      final calculator = GradeCalculator(); // Uses factory
      expect(calculator, isA<StandardGradeCalculator>());
      expect(calculator, isA<GradeCalculator>());
    });

    test('Polymorphism works: Different implementations produce different results', () {
      // 1. Define a polymorphic function that accepts ANY GradeCalculator
      String getGradeForAverage85(GradeCalculator calculator) {
        return calculator.assignGrade(85.0);
      }

      // 2. Instantiate two different implementations
      final standardCalc = StandardGradeCalculator();
      final strictCalc = StrictGradeCalculator();

      // 3. Verify that the same method call produces different results depending on the object type
      // Standard: 85 >= 80 -> 'A'
      expect(getGradeForAverage85(standardCalc), 'A');

      // Strict: 85 < 90 but >= 80 -> 'B'
      expect(getGradeForAverage85(strictCalc), 'B');
    });
  });

  group('StandardGradeCalculator Logic', () {
    final calculator = StandardGradeCalculator();

    test('computeAverage calculates correct mean', () {
      expect(calculator.computeAverage([80, 90, 100]), 90.0);
      expect(calculator.computeAverage([]), 0.0);
    });

    test('assignGrade maps scores correctly', () {
      expect(calculator.assignGrade(85), 'A');
      expect(calculator.assignGrade(75), 'B+');
      expect(calculator.assignGrade(65), 'B');
      expect(calculator.assignGrade(30), 'F');
    });
  });
}
