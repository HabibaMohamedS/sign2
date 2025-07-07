class QuizLogic {
  static int calculateScore(List<String> userAnswers, List<String> correctAnswers) {
    int score = 0;
    for (int i = 0; i < userAnswers.length; i++) {
      if (userAnswers[i] == correctAnswers[i]) {
        score += 10;
      }
    }
    return score;
  }
}
