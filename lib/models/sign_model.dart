class SignPrediction {
  final String arabicText;

  SignPrediction({required this.arabicText});

  factory SignPrediction.fromJson(String response) {
    return SignPrediction(arabicText: response);
  }
}
