import 'package:get/get_navigation/src/root/internacionalization.dart';

class MyLocale implements Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        "ar": {
          "1": "هيا بنا ننشأ حسابك",
          "2": "انشأ لي حساب؟",
          "3": "لديك حساب بالفعل",
          "4": "تسجيل دخول",
          "5": "تخطي",
        },
        "en": {
          "1": "Let's create your account",
          "2": "Sign me up",
          "3": "Already have an account?",
          "4": "Login",
          "5": "Skip"
        },
      };
}