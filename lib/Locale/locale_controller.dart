import 'dart:ui';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LocaleController extends GetxController {
  var currentLocale = const Locale('en', 'US').obs;

  void changeLocale(String languageCode, String countryCode) {
    final locale = Locale(languageCode, countryCode);
    currentLocale.value = locale;
    Get.updateLocale(locale);
  }
}