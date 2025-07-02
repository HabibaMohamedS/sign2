import 'package:get/get.dart';

class GradeController extends GetxController {
  final int correctAnswers;
  final int incorrectAnswers;

  GradeController({required this.correctAnswers, required this.incorrectAnswers});

  int get totalPoints => correctAnswers * 10;
}
