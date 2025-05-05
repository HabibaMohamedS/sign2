import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class VideoTranslateScreen extends StatefulWidget {
  const VideoTranslateScreen({super.key});

  @override
  _VideoTranslateScreenState createState() => _VideoTranslateScreenState();
}

class _VideoTranslateScreenState extends State<VideoTranslateScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  int _cameraIndex = 0;

  bool _isRecording = false;
  bool _isTranslating = false;
  String? _translation;
  XFile? _videoFile;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    print('🔧 Initializing cameras...');
    _cameras = await availableCameras();
    _controller = CameraController(
      _cameras![_cameraIndex],
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    await _controller!.initialize();
    print('✅ Camera initialized: ${_cameras![_cameraIndex].lensDirection}');
    setState(() {});
  }

  Future<void> _toggleCamera() async {
    print('🔄 Toggling camera...');
    if (_cameras!.length < 2) return;
    await _controller!.dispose();
    _cameraIndex = (_cameraIndex + 1) % _cameras!.length;
    _controller = CameraController(
      _cameras![_cameraIndex],
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    await _controller!.initialize();
    print('✅ Camera now: ${_cameras![_cameraIndex].lensDirection}');
    setState(() {});
  }

  Future<void> _onRecordButtonPressed() async {
    if (_isRecording) {
      print('⏹️ Stopping recording...');
      _videoFile = await _controller!.stopVideoRecording();
      print('📹 Video saved to ${_videoFile!.path}');
      setState(() {
        _isRecording = false;
        _isTranslating = true;
      });
      await _uploadAndTranslate(_videoFile!);
    } else {
      print('🔴 Starting recording...');
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';
      await _controller!.startVideoRecording();
      print('Recording to $filePath');
      setState(() => _isRecording = true);
    }
  }

  Future<void> _uploadAndTranslate(XFile file) async {
    try {
      final uri = Uri.parse('http://192.168.1.16:5000/translate_video');
      final req = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('video', file.path));
      print('📤 Uploading video...');
      final streamed = await req.send();
      print('⬇️ Waiting for response...');
      final respStr = await streamed.stream.bytesToString();
      print('📥 Response status: ${streamed.statusCode}');
      print('📄 Response body: $respStr');

      setState(() {
        _translation = streamed.statusCode == 200 ? respStr : 'Error ${streamed.statusCode}';
        _isTranslating = false;
      });
    } catch (e) {
      print('❌ Upload error: $e');
      setState(() {
        _translation = 'Upload failed';
        _isTranslating = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _buildTranslationPanel() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        color: Colors.white70,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isTranslating) ...[
              Text('Translating...', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              CircularProgressIndicator(),
            ] else ...[
              Text(_translation ?? '', style: TextStyle(fontSize: 20)),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _translation = null;
                  });
                },
                child: Text('Take another one'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_controller!),
          Positioned(
            top: 40,
            right: 20,
            child: FloatingActionButton(
              mini: true,
              onPressed: _toggleCamera,
              child: Icon(Icons.flip_camera_ios),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 80),
              child: FloatingActionButton(
                backgroundColor: _isRecording ? Colors.red : null,
                child: Icon(_isRecording ? Icons.stop : Icons.videocam),
                onPressed: _onRecordButtonPressed,
              ),
            ),
          ),
          if (_isTranslating || _translation != null) _buildTranslationPanel(),
        ],
      ),
    );
  }
}
