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
      _checkConnection();
    }) as StreamSubscription<ConnectivityResult>;
  }

 Future<void> _checkConnection() async {
  final wasConnected = connected.value;
  await Future.delayed(const Duration(seconds: 1));
  final isOnline = await InternetConnection.isDeviceOnline();
  log('wasConnected: $wasConnected, isOnline: $isOnline');
  connected.value = isOnline;

  if (!connected.value && wasConnected) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.rawSnackbar(
      message: 'PLEASE CONNECT TO THE INTERNET',
      isDismissible: false,
      duration: connected.value?Duration(seconds: 3): Duration(days: 1),
      margin: EdgeInsets.zero,
      snackStyle: SnackStyle.FLOATING,
      icon: const Icon(Icons.wifi_off_rounded, size: 35),
    );
  } else if (connected.value && !wasConnected) {
    log("connected");
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.rawSnackbar(
      message: 'CONNECTED TO THE INTERNET',
      isDismissible: true,
      margin: EdgeInsets.zero,
      snackStyle: SnackStyle.FLOATING,
      icon: const Icon(Icons.wifi_rounded, size: 35),
    );
  }
  else if(connected.value){
    log("connected");
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
  }
}

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
