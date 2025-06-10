import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:sign2/features/sign-to-text/viewmodels/sign_to_text_controller.dart';

class SignToTextScreen extends GetView<SignToTextController> {
  const SignToTextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        // controller.cameraController.value is a CameraController?
        final camCtrl = controller.cameraController.value;
        // Show loader until controller is non-null and initialized
        if (camCtrl == null || !camCtrl.value.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            // **Pass the CameraController itself**, not its .value!
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: camCtrl.value.previewSize!.height,
                height: camCtrl.value.previewSize!.width,
                child: CameraPreview(camCtrl),  // ← correct
              ),
            ),

            // Flip camera button
            Positioned(
              top: 40,
              right: 20,
              child: CircleAvatar(
                backgroundColor: Colors.black45,
                child: IconButton(
                  icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
                  onPressed: controller.toggleCamera,
                ),
              ),
            ),

            // Record/Stop button
            Obx(() {
              if (controller.isTranslating.value ||
                  controller.translation.value != null) {
                return const SizedBox.shrink();
              }
              return Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: GestureDetector(
                    onTap: controller.recordToggle,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: controller.isRecording.value
                            ? Colors.red
                            : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black54, width: 2),
                      ),
                      child: Icon(
                        controller.isRecording.value
                            ? Icons.stop
                            : Icons.videocam,
                        color: controller.isRecording.value
                            ? Colors.white
                            : Colors.black,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              );
            }),

            // Translation panel
            Obx(() {
              if (!controller.isTranslating.value &&
                  controller.translation.value == null) {
                return const SizedBox.shrink();
              }
              return Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (controller.isTranslating.value)
                        const Column(
                          children: [
                            Text(
                              'Translating...',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 12),
                            CircularProgressIndicator(),
                          ],
                        )
                      else
                        Column(
                          children: [
                            Text(
                              controller.translation.value ?? '',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            ElevatedButton.icon(
                              onPressed: controller.speakTranslation,
                              icon: const Icon(Icons.volume_up),
                              label: const Text('Listen'),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                controller.translation.value = null;
                                controller.isRecording.value = false;
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Translate Again'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      }),
    );
  }
}


// This widget is the main screen for the sign-to-text feature, 
//displaying the camera preview and translation results.