
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetConnection{

  static Future<bool> isDeviceOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
    // try {
    //   final result = await InternetAddress.lookup('google.com');
    //   return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    // } on SocketException catch (_) {
    //   return false;
    // }
  }
}