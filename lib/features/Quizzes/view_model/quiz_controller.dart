import 'dart:math';
import 'package:get/get.dart';
import '../../Learning_feature/model/data_sources/firebase_data_source.dart';
import '../../Learning_feature/model/models/lesson_model.dart';
import '../model/quiz_model.dart';
import '../view/grade_screen.dart';
import '../view/quiz_detsails_screen.dart';

class QuizController extends GetxController {
  RxList<QuizQuestion> quizQuestions = <QuizQuestion>[].obs;
  RxInt selectedOption = (-1).obs;
  RxInt currentQuestionIndex = 0.obs;
  RxBool isSubmitted = false.obs;
  RxInt correctAnswersCount = 0.obs;
  RxInt incorrectAnswersCount = 0.obs;

  List<LessonModel> allLessons = [];

  late String playlistId;
  late String title;

  Future<void> generateQuiz(List<LessonModel> lessons) async {
    allLessons = lessons;

    final questions = <QuizQuestion>[];

    for (var lesson in lessons) {
      final correctTitle = lesson.title ?? "Unknown";

      final otherLessons = List<LessonModel>.from(lessons)..remove(lesson);
      otherLessons.shuffle();

      final wrongTitles = otherLessons
          .take(3)
          .map((e) => e.title ?? "Wrong Option")
          .toList();

      final allOptions = [...wrongTitles, correctTitle]..shuffle();
      final correctIndex = allOptions.indexOf(correctTitle);

      questions.add(QuizQuestion(
        question: "63".tr,
        options: allOptions,
        correctAnswerIndex: correctIndex,
        videoUrl: lesson.videoId ?? "",
      ));
    }

    quizQuestions.value = questions;

    // Reset state
    selectedOption.value = -1;
    currentQuestionIndex.value = 0;
    isSubmitted.value = false;
    correctAnswersCount.value = 0;
    incorrectAnswersCount.value = 0;
  }

  Future<void> generateQuizFromPlaylist({
    required String playlistId,
    required String title,
  }) async {

    resetQuiz();
    this.playlistId = playlistId;
    this.title = title;

    final dataSource = FirebaseDataSource();
    final allLessons = await dataSource.fetchLessons(playlistId);
    allLessons.shuffle();

    final quizLessons = allLessons.length > 10
        ? allLessons.take(10).toList()
        : allLessons;

    await generateQuiz(quizLessons);

    Get.offAllNamed(
      QuizDetailsScreen.routeName,
      arguments: {
        'playlistId': playlistId,
        'title': title,
      },
    );
  }

  void selectOption(int index) {
    selectedOption.value = index;
  }

  bool isAnswerCorrect() {
    return selectedOption.value ==
        quizQuestions[currentQuestionIndex.value].correctAnswerIndex;
  }

  void submitAnswer() {
    if (selectedOption.value == -1) return;

    if (isAnswerCorrect()) {
      correctAnswersCount++;
    } else {
      incorrectAnswersCount++;
    }

    isSubmitted.value = true;
  }

  void goToNextQuestion() {
    if (currentQuestionIndex.value < quizQuestions.length - 1) {
      currentQuestionIndex.value++;
      selectedOption.value = -1;
      isSubmitted.value = false;
    } else {
      Get.offNamed(
        GradeScreen.routeName,
        arguments: {
          'correct': correctAnswersCount.value,
          'incorrect': incorrectAnswersCount.value,
          'playlistId': playlistId,
          'title': title,
        },
      );
    }
  }

  void resetQuiz() {
    selectedOption.value = -1;
    currentQuestionIndex.value = 0;
    isSubmitted.value = false;
    correctAnswersCount.value = 0;
    incorrectAnswersCount.value = 0;
    quizQuestions.clear();
    allLessons.clear();
  }

  String get currentVideoId {
    final index = currentQuestionIndex.value;
    return allLessons[index].videoId ?? '';
  }
}
