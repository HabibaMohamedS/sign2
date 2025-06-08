import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(SignLanguageApp());
}

class SignLanguageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sign Language Recognition',
      theme: ThemeData.dark(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}

