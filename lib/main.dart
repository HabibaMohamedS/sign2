import 'package:flutter/material.dart';
import 'cameraview.dart';

void main() {
  runApp(SignLanguageApp());
}

class SignLanguageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Language Recognition',
      theme: ThemeData.dark(),
      home: CameraView(),
    );
  }
}
