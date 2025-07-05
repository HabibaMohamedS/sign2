import 'package:get/get.dart';
import 'package:sign2/support/network/network_controller.dart';


class NetworkDepencyInjection {
  static void init(){
    Get.put<NetworkController>(NetworkController(),permanent: true);
  }
}