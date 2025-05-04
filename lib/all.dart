import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart' show FlexDelegate; // if you're using helpers


class SignLanguageRecognition extends StatefulWidget {
  @override
  _SignLanguageRecognitionState createState() =>
      _SignLanguageRecognitionState();
}

class _SignLanguageRecognitionState extends State<SignLanguageRecognition> {
  CameraController? _cameraController;
  late Interpreter _interpreter;
  bool _isInterpreterReady = false;
  bool _isCameraInitialized = false;
  bool _isCapturing = false;

  List<String> actions = [
    'baby',
    'eat',
    'father',
    'finish',
    'good',
    'happy',
    'hear',
    'house',
    'important',
    'love',
    'mall',
    'me',
    'mosque',
    'mother',
    'normal',
    'sad',
    'stop',
    'thanks',
    'thinking',
    'worry',
  ];

  List<List<double>> sequence = [];
  List<String> sentence = [];
  final int windowSize = 30;
  final double threshold = 0.85;

  int _cameraIndex = 0;
  List<CameraDescription> _cameras = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadModel();
    await _initializeCamera();
  }

  Future<void> _loadModel() async {
  print("LOADING MODEL WITH FLEX DELEGATE...");
  try {
    final options = InterpreterOptions()..addDelegate(FlexDelegate());
  _interpreter = await Interpreter.fromAsset('assets/modelh5.tflite', options: options);
  _isInterpreterReady = true;
    print("Model loaded successfully with Flex support.");
  } catch (e) {
    print("Failed to load model with Flex delegate: $e");
  }
}
  // Future<void> _loadModel() async {
  //   print("LOADING MODEL.....................");
  //   try {
  //     final interpreterOptions = InterpreterOptions()
  //     ..addDelegate(FlexDelegate());

  //     _interpreter = await Interpreter.fromAsset('assets/modelh5.tflite', options: interpreterOptions);

  //     // _interpreter = await Interpreter.fromAsset('assets/modelh5.tflite');
  //     // _isInterpreterReady = true;
  //     print("Model loaded successfully.");
  //   } catch (e) {
  //     print("Failed to load model: $e");
  //   }
  // }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      _cameraController = CameraController(
        _cameras[_cameraIndex],
        ResolutionPreset.medium,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      // _cameraController = CameraController(
      //   _cameras[_cameraIndex],
      //   ResolutionPreset.medium,
      // );

      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });

      Timer.periodic(Duration(seconds: 1), (timer) {
        processCameraImage();
      });
      // _cameraController!.startImageStream((image) async {
      //   if (!_isCameraInitialized) return;
      //   processCameraImage(image);
      // });
    } catch (e) {
      print("Camera initialization error: $e");
    }
  }

  //   void _flipCamera() async {
  //     if (_cameras.length < 2) return;

  //     setState(() {
  //       _isCameraInitialized = false;
  //     });

  //     await _cameraController?.stopImageStream();
  //     await _cameraController?.dispose();

  //     _cameraIndex = (_cameraIndex + 1) % _cameras.length;
  //     _cameraController = CameraController(
  //   _cameras[_cameraIndex],
  //   ResolutionPreset.medium,
  //   imageFormatGroup: ImageFormatGroup.jpeg,
  // );

  //     // _cameraController = CameraController(
  //     //   _cameras[_cameraIndex],
  //     //   ResolutionPreset.medium,
  //     // );

  //     await _cameraController!.initialize();
  //     setState(() {
  //       _isCameraInitialized = true;
  //     });

  //     Timer.periodic(Duration(seconds: 2), (timer) {
  //     processCameraImage();
  //     });

  //     // _cameraController!.startImageStream((image) async {
  //     //   if (!_isCameraInitialized) return;
  //     //   processCameraImage(image);
  //     // });
  //   }

  void _flipCamera() async {
    if (_cameras.length < 2) return;

    setState(() {
      _isCameraInitialized = false;
    });

    await _cameraController?.dispose();

    _cameraIndex = (_cameraIndex + 1) % _cameras.length;
    _cameraController = CameraController(
      _cameras[_cameraIndex],
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.jpeg, // ✅ ensure consistent format
    );

    try {
      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });

      Timer.periodic(Duration(seconds: 1), (timer) {
        processCameraImage();
      });
    } catch (e) {
      print("Front camera initialization failed: $e");
    }
  }

  Future<List<double>> _processImage(Uint8List imageBytes) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.16:5000/process'),
      );
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: 'frame.jpg',
        ),
      );
      print("Sending image to server...");

      var response = await request.send();
      var jsonResponse = await response.stream.bytesToString();
      var decoded = json.decode(jsonResponse);
      print("Decoded keypoints: $decoded");
      return List<double>.from(decoded['keypoints']);
    } catch (e) {
      print("Error processing image: $e");
      return List.filled(543, 0.0);
    }
  }

  Future<Uint8List> _convertToBytes(CameraImage image) async {
    final WriteBuffer buffer = WriteBuffer();
    for (var plane in image.planes) {
      buffer.putUint8List(plane.bytes);
    }
    return buffer.done().buffer.asUint8List();
  }

  void processCameraImage() async {
    if (_isCapturing) return; // prevent overlap
    _isCapturing = true;

    try {
      if (_cameraController == null ||
          !_cameraController!.value.isInitialized) {
        _isCapturing = false;
        return;
      }

      XFile file = await _cameraController!.takePicture();
      Uint8List bytes = await file.readAsBytes();

      List<double> keypoints = await _processImage(bytes);

      sequence.add(keypoints);
      print("SEQUENCE LENGHT ${sequence.length}");
      if (sequence.length > windowSize) sequence.removeAt(0);

      if (sequence.length == windowSize) {
        _predictSign();
      }
    } catch (e) {
      print("Error capturing image: $e");
    } finally {
      _isCapturing = false; // release the flag
    }
  }

  //   void processCameraImage() async {
  //   try {
  //     if (_cameraController == null || !_cameraController!.value.isInitialized) {
  //       return;
  //     }

  //     // 📸 Take a real JPEG picture
  //     XFile file = await _cameraController!.takePicture();
  //     Uint8List bytes = await file.readAsBytes();

  //     // Now send this to Python server
  //     List<double> keypoints = await _processImage(bytes);

  //     sequence.add(keypoints);
  //     if (sequence.length > windowSize) sequence.removeAt(0);

  //     if (sequence.length == windowSize) {
  //       _predictSign();
  //     }
  //   } catch (e) {
  //     print("Error capturing image: $e");
  //   }
  // }

  // void processCameraImage(CameraImage image) async {
  //   final Uint8List imageBytes = await _convertToBytes(image);
  //   List<double> keypoints = await _processImage(imageBytes);

  //   sequence.add(keypoints);
  //   if (sequence.length > windowSize) sequence.removeAt(0);

  //   if (sequence.length == windowSize) {
  //     _predictSign();
  //   }
  // }

  void _predictSign() {
    if (sequence.isEmpty || !_isInterpreterReady) return;

    print("Predicting sign...");
    var input = [sequence.map((e) => Float32List.fromList(e)).toList()];
    var output = List.filled(actions.length, 0.0).reshape([1, actions.length]);

    _interpreter.run(input, output);

    int predictedIndex = output[0].indexOf(output[0].reduce(max));

    if (output[0][predictedIndex] > threshold) {
      String predictedAction = actions[predictedIndex];
      if (sentence.isEmpty || predictedAction != sentence.last) {
        setState(() {
          sentence.add(predictedAction);
          if (sentence.length > 5) sentence.removeAt(0);
        });
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Language Recognition")),
      body:
          _isCameraInitialized && _cameraController != null
              ? Stack(
                children: [
                  SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _cameraController!.value.previewSize!.height,
                        height: _cameraController!.value.previewSize!.width,
                        child: CameraPreview(_cameraController!),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      padding: EdgeInsets.all(12),
                      child: Text(
                        sentence.join(" "),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              )
              : Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: _flipCamera,
        child: Icon(Icons.cameraswitch),
      ),
    );
  }
}
