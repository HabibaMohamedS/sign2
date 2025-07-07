import 'package:flutter_test/flutter_test.dart';
import 'package:sign2/utils/quiz_logic.dart';

void main() {
  group('Quiz Score Calculation', () {
    test('All correct answers (3 questions)', () {
      final userAnswers = ['A', 'B', 'C'];
      final correctAnswers = ['A', 'B', 'C'];

      expect(QuizLogic.calculateScore(userAnswers, correctAnswers), 30);
    });

    test('Some correct answers (2 correct)', () {
      final userAnswers = ['A', 'B', 'D'];
      final correctAnswers = ['A', 'C', 'D'];

      expect(QuizLogic.calculateScore(userAnswers, correctAnswers), 20);
    });

    test('No correct answers', () {
      final userAnswers = ['A', 'B', 'C'];
      final correctAnswers = ['D', 'E', 'F'];

      expect(QuizLogic.calculateScore(userAnswers, correctAnswers), 0);
    });

    test('Empty answers', () {
      expect(QuizLogic.calculateScore([], []), 0);
    });
  });
}
