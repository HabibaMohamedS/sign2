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
    _cameras = await availableCameras();
    _controller = CameraController(
      _cameras![_cameraIndex],
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    await _controller!.initialize();
    setState(() {});
  }

  Future<void> _toggleCamera() async {
    if (_cameras!.length < 2) return;
    await _controller!.dispose();
    _cameraIndex = (_cameraIndex + 1) % _cameras!.length;
    _controller = CameraController(
      _cameras![_cameraIndex],
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    await _controller!.initialize();
    setState(() {});
  }

  Future<void> _onRecordButtonPressed() async {
    if (_isRecording) {
      _videoFile = await _controller!.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _isTranslating = true;
      });
      await _uploadAndTranslate(_videoFile!);
    } else {
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';
      await _controller!.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }

  Future<void> _uploadAndTranslate(XFile file) async {
    try {
      final uri = Uri.parse('http://192.168.1.13:5000/translate_video');
      final req = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('video', file.path));
      final streamed = await req.send();
      final respStr = await streamed.stream.bytesToString();

      setState(() {
        _translation = streamed.statusCode == 200 ? respStr : 'Error ${streamed.statusCode}';
        _isTranslating = false;
      });
    } catch (e) {
      setState(() {
        _translation = 'Upload failed: $e';
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
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isTranslating) ...[
              Text('Translating...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              const SizedBox(height: 12),
              CircularProgressIndicator(),
            ] else ...[
              Text(
                _translation ?? '',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _translation = null;
                    _isRecording = false;
                  });
                },
                icon: Icon(Icons.refresh),
                label: Text('Translate Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
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
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller!.value.previewSize!.height,
                height: _controller!.value.previewSize!.width,
                child: CameraPreview(_controller!),
              ),
            ),
          ),

          // Flip camera button
          Positioned(
            top: 40,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.flip_camera_ios, color: Colors.white),
                onPressed: _toggleCamera,
              ),
            ),
          ),

          // Recording button
          if (!_isTranslating && _translation == null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: GestureDetector(
                  onTap: _onRecordButtonPressed,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _isRecording ? Colors.red : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black54, width: 2),
                    ),
                    child: Icon(
                      _isRecording ? Icons.stop : Icons.videocam,
                      color: _isRecording ? Colors.white : Colors.black,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),

          // Translation overlay
          if (_isTranslating || _translation != null) _buildTranslationPanel(),
        ],
      ),
    );
  }
}
