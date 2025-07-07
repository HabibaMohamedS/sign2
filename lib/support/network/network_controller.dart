import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign2/support/network/internet_connetion.dart';

class NetworkController extends GetxController {
  RxBool connected = true.obs;
  late StreamSubscription<ConnectivityResult> _subscription;
  @override
  void onInit() {
    super.onInit();
    _checkConnection();
    _subscription = Connectivity().onConnectivityChanged.listen((result) async {
      // connected.value = await InternetConnection.isDeviceOnline();
      _checkConnection();
    });
  }

 Future<void> _checkConnection() async {
  final wasConnected = connected.value;
  connected.value = await InternetConnection.isDeviceOnline();

  // Debug logs
  log('wasConnected: $wasConnected, connected: ${connected.value}');

  if (!connected.value && wasConnected) {
    // Just lost connection
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.rawSnackbar(
      message: 'PLEASE CONNECT TO THE INTERNET',
      isDismissible: false,
      duration: const Duration(days: 1),
      margin: EdgeInsets.zero,
      snackStyle: SnackStyle.FLOATING,
      icon: const Icon(Icons.wifi_off_rounded, size: 35),
    );
  } else if (connected.value && !wasConnected) {
    // Just regained connection
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.rawSnackbar(
      message: 'CONNECTED TO THE INTERNET',
      isDismissible: true,
      margin: EdgeInsets.zero,
      snackStyle: SnackStyle.FLOATING,
      icon: const Icon(Icons.wifi_rounded, size: 35),
    );
  }
  // No snackbar if there is no state change
}

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
