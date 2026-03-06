import 'package:test/test.dart';
import 'package:student_grade_calculator/services/grade_calculator.dart';

void main() {
  late GradeCalculator calculator;

  setUp(() {
    calculator = GradeCalculator();
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Tests for computeAverage
  // ═══════════════════════════════════════════════════════════════════════════

  group('computeAverage', () {
    test('empty list returns 0.0', () {
      expect(calculator.computeAverage([]), equals(0.0));
    });

    test('single score returns that score', () {
      expect(calculator.computeAverage([75.0]), equals(75.0));
    });

    test('multiple scores returns correct mean', () {
      // (80 + 60 + 70) / 3 = 70
      expect(calculator.computeAverage([80.0, 60.0, 70.0]), equals(70.0));
    });

    test('handles decimal averages', () {
      // (85 + 90 + 78 + 88) / 4 = 85.25
      expect(
        calculator.computeAverage([85.0, 90.0, 78.0, 88.0]),
        equals(85.25),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Tests for assignGrade — every boundary value
  // ═══════════════════════════════════════════════════════════════════════════

  group('assignGrade', () {
    test('100 → A', () => expect(calculator.assignGrade(100), equals('A')));
    test('80 → A', () => expect(calculator.assignGrade(80), equals('A')));
    test('79 → B+', () => expect(calculator.assignGrade(79), equals('B+')));
    test('70 → B+', () => expect(calculator.assignGrade(70), equals('B+')));
    test('69 → B', () => expect(calculator.assignGrade(69), equals('B')));
    test('60 → B', () => expect(calculator.assignGrade(60), equals('B')));
    test('59 → C+', () => expect(calculator.assignGrade(59), equals('C+')));
    test('55 → C+', () => expect(calculator.assignGrade(55), equals('C+')));
    test('54 → C', () => expect(calculator.assignGrade(54), equals('C')));
    test('50 → C', () => expect(calculator.assignGrade(50), equals('C')));
    test('49 → D+', () => expect(calculator.assignGrade(49), equals('D+')));
    test('45 → D+', () => expect(calculator.assignGrade(45), equals('D+')));
    test('44 → D', () => expect(calculator.assignGrade(44), equals('D')));
    test('40 → D', () => expect(calculator.assignGrade(40), equals('D')));
    test('39 → F', () => expect(calculator.assignGrade(39), equals('F')));
    test('0 → F', () => expect(calculator.assignGrade(0), equals('F')));
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Tests for assignGpa — mirrors assignGrade boundaries
  // ═══════════════════════════════════════════════════════════════════════════

  group('assignGpa', () {
    test('100 → 4.0', () => expect(calculator.assignGpa(100), equals(4.0)));
    test('80 → 4.0', () => expect(calculator.assignGpa(80), equals(4.0)));
    test('79 → 3.5', () => expect(calculator.assignGpa(79), equals(3.5)));
    test('70 → 3.5', () => expect(calculator.assignGpa(70), equals(3.5)));
    test('69 → 3.0', () => expect(calculator.assignGpa(69), equals(3.0)));
    test('60 → 3.0', () => expect(calculator.assignGpa(60), equals(3.0)));
    test('59 → 2.5', () => expect(calculator.assignGpa(59), equals(2.5)));
    test('55 → 2.5', () => expect(calculator.assignGpa(55), equals(2.5)));
    test('54 → 2.0', () => expect(calculator.assignGpa(54), equals(2.0)));
    test('50 → 2.0', () => expect(calculator.assignGpa(50), equals(2.0)));
    test('49 → 1.5', () => expect(calculator.assignGpa(49), equals(1.5)));
    test('45 → 1.5', () => expect(calculator.assignGpa(45), equals(1.5)));
    test('44 → 1.0', () => expect(calculator.assignGpa(44), equals(1.0)));
    test('40 → 1.0', () => expect(calculator.assignGpa(40), equals(1.0)));
    test('39 → 0.0', () => expect(calculator.assignGpa(39), equals(0.0)));
    test('0 → 0.0', () => expect(calculator.assignGpa(0), equals(0.0)));
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Tests for determineStatus
  // ═══════════════════════════════════════════════════════════════════════════

  group('determineStatus', () {
    test('"F" → FAIL', () {
      expect(calculator.determineStatus('F'), equals('FAIL'));
    });

    test('"A" → PASS', () {
      expect(calculator.determineStatus('A'), equals('PASS'));
    });

    test('"B+" → PASS', () {
      expect(calculator.determineStatus('B+'), equals('PASS'));
    });

    test('"B" → PASS', () {
      expect(calculator.determineStatus('B'), equals('PASS'));
    });

    test('"C+" → PASS', () {
      expect(calculator.determineStatus('C+'), equals('PASS'));
    });

    test('"C" → PASS', () {
      expect(calculator.determineStatus('C'), equals('PASS'));
    });

    test('"D+" → PASS', () {
      expect(calculator.determineStatus('D+'), equals('PASS'));
    });

    test('"D" → PASS', () {
      expect(calculator.determineStatus('D'), equals('PASS'));
    });
  });
}
