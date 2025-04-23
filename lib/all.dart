// import 'dart:typed_data';
// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:google_mlkit_hand_tracking/google_mlkit_hand_tracking.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';

// class SignLanguageRecognition extends StatefulWidget {
//   @override
//   _SignLanguageRecognitionState createState() => _SignLanguageRecognitionState();
// }

// class _SignLanguageRecognitionState extends State<SignLanguageRecognition> {
//   CameraController? _cameraController;
//   late Interpreter _interpreter;
//   final poseDetector = PoseDetector(options: PoseDetectorOptions());
//   final faceDetector = FaceDetector(options: FaceDetectorOptions(enableLandmarks: true));
//   final handDetector = HandDetector(options: HandDetectorOptions());

//   List<String> actions = [
//     'baby', 'eat', 'father', 'finish', 'good', 'happy', 'hear', 'house',
//     'important', 'love', 'mall', 'me', 'mosque', 'mother', 'normal', 'sad',
//     'stop', 'thanks', 'thinking', 'worry'
//   ];

//   List<List<double>> sequence = [];
//   List<String> sentence = [];
//   final int windowSize = 30;
//   final double threshold = 0.85;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//     _loadModel();
//   }

//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
//     await _cameraController!.initialize();
//     _cameraController!.startImageStream((image) async {
//       processCameraImage(image);
//     });
//   }

//   Future<void> _loadModel() async {
//     _interpreter = await Interpreter.fromAsset('assets/modelh5.tflite');
//   }

//   void processCameraImage(CameraImage image) async {
//     final InputImage inputImage = _convertToInputImage(image);

//     Pose? pose = await detectPose(inputImage);
//     Face? face = await detectFace(inputImage);
//     List<Hand> hands = await detectHands(inputImage);

//     Hand? leftHand;
//     Hand? rightHand;

//     if (hands.isNotEmpty) {
//       leftHand = hands.length > 1 ? hands[0] : null;
//       rightHand = hands.length > 1 ? hands[1] : hands[0];
//     }

//     List<double> keypoints = _extractKeypoints(pose, face, leftHand, rightHand);
//     sequence.add(keypoints);

//     if (sequence.length > windowSize) sequence.removeAt(0);
//     if (sequence.length == windowSize) {
//       _predictSign();
//     }
//   }

//   Future<Pose?> detectPose(InputImage inputImage) async {
//     final List<Pose> poses = await poseDetector.processImage(inputImage);
//     return poses.isNotEmpty ? poses.first : null;
//   }

//   Future<Face?> detectFace(InputImage inputImage) async {
//     final List<Face> faces = await faceDetector.processImage(inputImage);
//     return faces.isNotEmpty ? faces.first : null;
//   }

//   Future<List<Hand>> detectHands(InputImage inputImage) async {
//     return await handDetector.processImage(inputImage);
//   }

//   InputImage _convertToInputImage(CameraImage image) {
//     final WriteBuffer buffer = WriteBuffer();
//     for (var plane in image.planes) {
//       buffer.putUint8List(plane.bytes);
//     }
//     final bytes = buffer.done().buffer.asUint8List();

//     return InputImage.fromBytes(
//       bytes: bytes,
//       metadata: InputImageMetadata(
//         size: Size(image.width.toDouble(), image.height.toDouble()),
//         rotation: InputImageRotation.rotation0deg,
//         format: InputImageFormat.yuv420,
//         bytesPerRow: image.planes[0].bytesPerRow,
//       ),
//     );
//   }

//   List<double> _extractKeypoints(Pose? pose, Face? face, Hand? leftHand, Hand? rightHand) {
//     List<double> keypoints = [];

//     // Extract 33 Pose Landmarks
//     if (pose != null) {
//       for (PoseLandmark landmark in pose.landmarks.values) {
//         keypoints.add(landmark.x);
//         keypoints.add(landmark.y);
//         keypoints.add(landmark.z);
//       }
//     }
//     while (keypoints.length < 132) keypoints.add(0.0); // 33 * 4

//     // Extract 468 Face Landmarks
//     if (face != null) {
//       for (FaceLandmark landmark in face.landmarks.values) {
//         keypoints.add(landmark.x);
//         keypoints.add(landmark.y);
//         keypoints.add(landmark.z);
//       }
//     }
//     while (keypoints.length < 132 + 1404) keypoints.add(0.0); // 468 * 3

//     // Extract 21 Left-Hand Landmarks
//     if (leftHand != null) {
//       for (HandLandmark landmark in leftHand.landmarks.values) {
//         keypoints.add(landmark.x);
//         keypoints.add(landmark.y);
//         keypoints.add(landmark.z);
//       }
//     }
//     while (keypoints.length < 132 + 1404 + 63) keypoints.add(0.0); // 21 * 3

//     // Extract 21 Right-Hand Landmarks
//     if (rightHand != null) {
//       for (HandLandmark landmark in rightHand.landmarks.values) {
//         keypoints.add(landmark.x);
//         keypoints.add(landmark.y);
//         keypoints.add(landmark.z);
//       }
//     }
//     while (keypoints.length < 132 + 1404 + 63 + 63) keypoints.add(0.0); // 21 * 3

//     return keypoints;
//   }

//   void _predictSign() {
//     var input = [sequence];
//     var output = List.filled(1 * actions.length, 0.0).reshape([1, actions.length]);

//     _interpreter.run(input, output);

//     int predictedIndex = output[0]
//         .indexWhere((val) => val == output[0].reduce((a, b) => a > b ? a : b));

//     if (output[0][predictedIndex] > threshold) {
//       String predictedAction = actions[predictedIndex];

//       if (sentence.isEmpty || predictedAction != sentence.last) {
//         setState(() {
//           sentence.add(predictedAction);
//           if (sentence.length > 5) sentence.removeAt(0);
//         });
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     _interpreter.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Sign Language Recognition")),
//       body: Column(
//         children: [
//           _cameraController != null && _cameraController!.value.isInitialized
//               ? AspectRatio(
//                   aspectRatio: _cameraController!.value.aspectRatio,
//                   child: CameraPreview(_cameraController!),
//                 )
//               : Center(child: CircularProgressIndicator()),
//           SizedBox(height: 20),
//           Text(
//             sentence.join(" "),
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'dart:convert';

// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
//  import 'package:http/http.dart' as http;
// class SignLanguageRecognition extends StatefulWidget {
//   @override
//   _SignLanguageRecognitionState createState() => _SignLanguageRecognitionState();
// }

// class _SignLanguageRecognitionState extends State<SignLanguageRecognition> {
//   CameraController? _cameraController;
//   late Interpreter _interpreter;

//   List<String> actions = [
//     'baby', 'eat', 'father', 'finish', 'good', 'happy', 'hear', 'house',
//     'important', 'love', 'mall', 'me', 'mosque', 'mother', 'normal', 'sad',
//     'stop', 'thanks', 'thinking', 'worry'
//   ];
//   List<List<double>> sequence = [];
//   List<String> sentence = [];
//   final int windowSize = 30;
//   final double threshold = 0.85;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//     _loadModel();
//   }

//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
//     await _cameraController!.initialize();
//     _cameraController!.startImageStream((image) async {
//       processCameraImage(image);
//     });
//   }

//   Future<void> _loadModel() async {
//     _interpreter = await Interpreter.fromAsset('assets/modelh5.tflite');
//   }

// Future<List<double>> _processImage(Uint8List imageBytes) async {
//   var request = http.MultipartRequest('POST', Uri.parse('http://YOUR_SERVER_IP:5000/process'));
//   request.files.add(http.MultipartFile.fromBytes('image', imageBytes, filename: 'frame.jpg'));

//   var response = await request.send();
//   var jsonResponse = await response.stream.bytesToString();

//   var decoded = json.decode(jsonResponse);
//   return List<double>.from(decoded['keypoints']);
// }

//   InputImage _convertToInputImage(CameraImage image) {
//     final WriteBuffer buffer = WriteBuffer();
//     for (var plane in image.planes) {
//       buffer.putUint8List(plane.bytes);
//     }
//     final bytes = buffer.done().buffer.asUint8List();

//     return InputImage.fromBytes(
//       bytes: bytes,
//       metadata: InputImageMetadata(
//         size: Size(image.width.toDouble(), image.height.toDouble()),
//         rotation: InputImageRotation.rotation0deg,
//         format: InputImageFormat.yuv420,
//         bytesPerRow: image.planes[0].bytesPerRow,
//       ),
//     );
//   }
// void processCameraImage(CameraImage image) async {
//   final InputImage inputImage = _convertToInputImage(image);
//   final Uint8List imageBytes = inputImage.bytes!;

//   List<double> keypoints = await _processImage(imageBytes);
//   sequence.add(keypoints);

//   if (sequence.length > windowSize) sequence.removeAt(0);
//   if (sequence.length == windowSize) {
//     _predictSign();
//   }
// }

//   // List<double> _extractKeypoints(List<Pose> poses, List<HandLandmark> hands) {
//   //   Pose pose = poses.first;
//   //   List<double> keypoints = [];

//   //   // Extract 33 Pose Landmarks
//   //   for (PoseLandmark landmark in pose.landmarks.values) {
//   //     keypoints.add(landmark.x);
//   //     keypoints.add(landmark.y);
//   //     keypoints.add(landmark.z);
//   //   }

//   //   // Extract Hand Landmarks (if available)
//   //   for (var hand in hands) {
//   //     for (var point in hand.landmarks) {
//   //       keypoints.add(point.x);
//   //       keypoints.add(point.y);
//   //       keypoints.add(point.z);
//   //     }
//   //   }

//   //   // Fill missing keypoints with zeros if needed
//   //   while (keypoints.length < 132 + 21 * 3 * 2) {
//   //     keypoints.add(0.0);
//   //   }

//   //   return keypoints;
//   // }

//   void _predictSign() {
//     var input = [sequence];
//     var output = List.filled(1 * actions.length, 0.0).reshape([1, actions.length]);
//     _interpreter.run(input, output);

//     int predictedIndex = output[0].indexWhere((val) => val == output[0].reduce((a, b) => a > b ? a : b));

//     if (output[0][predictedIndex] > threshold) {
//       String predictedAction = actions[predictedIndex];
//       if (sentence.isEmpty || predictedAction != sentence.last) {
//         setState(() {
//           sentence.add(predictedAction);
//           if (sentence.length > 5) sentence.removeAt(0);
//         });
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     _interpreter.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Sign Language Recognition")),
//       body: Column(
//         children: [
//           _cameraController != null && _cameraController!.value.isInitialized
//               ? AspectRatio(
//                   aspectRatio: _cameraController!.value.aspectRatio,
//                   child: CameraPreview(_cameraController!),
//                 )
//               : Center(child: CircularProgressIndicator()),
//           SizedBox(height: 20),
//           Text(
//             sentence.join(" "),
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:typed_data/typed_data.dart';

import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:http/http.dart' as http;

class SignLanguageRecognition extends StatefulWidget {
  @override
  _SignLanguageRecognitionState createState() =>
      _SignLanguageRecognitionState();
}

class _SignLanguageRecognitionState extends State<SignLanguageRecognition> {
  CameraController? _cameraController;
  late Interpreter _interpreter;

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

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
  }

  Future<void> _initializeCamera() async {
    print("Initializing camera...");
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    await _cameraController!.initialize();
    _cameraController!.startImageStream((image) async {
      processCameraImage(image);
    });
  }

  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/modelh5.tflite');
    print("Model loaded successfully.");
  }

  /// **Sends Image to Python Server for Pose, Face & Hands Extraction**
  Future<List<double>> _processImage(Uint8List imageBytes) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'http://192.168.1.107:5000',
        ), // 🔹 Replace with your actual server IP
      );
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: 'frame.jpg',
        ),
      );

      var response = await request.send();
      var jsonResponse = await response.stream.bytesToString();

      var decoded = json.decode(jsonResponse);
      return List<double>.from(decoded['keypoints']);
    } catch (e) {
      print("Error processing image: $e");
      return List.filled(543, 0.0); // Return default empty keypoints
    }
  }

  /// **Converts CameraImage to InputImage**
  Future<Uint8List> _convertToBytes(CameraImage image) async {
    final WriteBuffer buffer = WriteBuffer();
    for (var plane in image.planes) {
      buffer.putUint8List(plane.bytes);
    }
    return buffer.done().buffer.asUint8List();
  }

  /// **Processes Camera Image and Extracts Keypoints**
  void processCameraImage(CameraImage image) async {
    final Uint8List imageBytes = await _convertToBytes(image);
    List<double> keypoints = await _processImage(imageBytes);

    sequence.add(keypoints);
    if (sequence.length > windowSize) sequence.removeAt(0);

    if (sequence.length == windowSize) {
      _predictSign();
    }
  }

  /// **Runs TFLite Model to Predict Sign Language Gesture**
  void _predictSign() {
    if (sequence.isEmpty) return;
    print("Predicting sign...");
    var input = [sequence.map((e) => Float32List.fromList(e)).toList()];
    var output = List.filled(actions.length, 0.0).reshape([1, actions.length]);

    _interpreter.run(input, output);

    // int predictedIndex = output[0].indexWhere(
    //   (val) => val == output[0].reduce((a, b) => a > b ? a : b),
    // );
    int predictedIndex = output[0].indexOf(output[0].reduce(max));

    if (output[0][predictedIndex] > threshold) {
      String predictedAction = actions[predictedIndex];
      print("Predicted Action: $predictedAction");
      print("Confidence: ${output[0][predictedIndex]}");
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
      body: Column(
        children: [
          _cameraController != null && _cameraController!.value.isInitialized
              ? AspectRatio(
                aspectRatio: _cameraController!.value.aspectRatio,
                child: CameraPreview(_cameraController!),
              )
              : Center(child: CircularProgressIndicator()),
          SizedBox(height: 20),
          Text(
            sentence.join(" "),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
