import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'imageProcessing.dart';

class CameraView extends StatefulWidget {
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController =
        CameraController(_cameras!.first, ResolutionPreset.medium);
    await _cameraController!.initialize();

    if (!mounted) return;

    setState(() {});

    _cameraController!.startImageStream((CameraImage image) {
      processCameraImage(image);
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _cameraController != null && _cameraController!.value.isInitialized
          ? CameraPreview(_cameraController!)
          : Center(child: CircularProgressIndicator()),
    );
  }
}
