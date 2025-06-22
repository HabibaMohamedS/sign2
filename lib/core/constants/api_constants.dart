class ApiConstants {
  static const String baseUrl = 'http://192.168.1.47:5000'; //to change IP address
  static const String translateVideoEndpoint = '/translate_video';

  // Full URL builder
  static String get translateVideoUrl => '$baseUrl$translateVideoEndpoint';
}
