
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetConnection{

  static Future<bool> isDeviceOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }
}