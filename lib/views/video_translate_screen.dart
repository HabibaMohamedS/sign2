import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../viewmodels/video_translate_viewmodel.dart';

class VideoTranslateScreen extends StatelessWidget {
  final VideoTranslateViewModel controller = Get.find();

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final picked = await picker.pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      await controller.translateVideo(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("مترجم لغة الإشارة")),
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {
            return CircularProgressIndicator();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _pickVideo,
                child: Text("اختر فيديو من المعرض"),
              ),
              SizedBox(height: 20),
              Text(
                controller.prediction.value,
                style: TextStyle(fontSize: 20),
              ),
            ],
          );
        }),
      ),
    );
  }
}
