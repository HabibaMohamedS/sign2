import 'package:get/get.dart';
import 'package:sign2/features/sign-to-text/viewmodels/sign_to_text_controller.dart';

class SignToTextBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignToTextController());
  }
}
