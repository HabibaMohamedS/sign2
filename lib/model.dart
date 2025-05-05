// // import 'package:tflite_flutter/tflite_flutter.dart';
// // import 'package:camera/camera.dart';
// // import 'dart:typed_data';

// // class SignLanguageModel {
// //   late Interpreter _interpreter;

// //   Future<void> loadModel() async {
// //     _interpreter = await Interpreter.fromAsset('modelh5.tflite');
// //   }

// //   List<dynamic> runInference(Uint8List imageData) {
// //     // Preprocess the imageData as required by your model
// //     // For example, resizing and normalizing
// //     var input = preprocessImage(imageData);
// //     var output =
// //         List.filled(1 * 1, 0).reshape([1, 1]); // Adjust as per your model
// //     _interpreter.run(input, output);
// //     return output;
// //   }

// //   List preprocessImage(Uint8List imageData) {
// //     // Implement preprocessing (resize, normalize, etc.)
// //     return [];
// //   }
// // }
// import 'package:tflite_flutter/tflite_flutter.dart';

// Interpreter? _interpreter;
// List<List<double>> sequence = [];

// void loadModel() async {
//   _interpreter = await Interpreter.fromAsset('model.tflite');
// }

// List actions = [
//   'baby',
//   'eat',
//   'father',
//   'finish',
//   'good',
//   'happy',
//   'hear',
//   'house',
//   'important',
//   'love',
//   'mall',
//   'me',
//   'mosque',
//   'mother',
//   'normal',
//   'sad',
//   'stop',
//   'thanks',
//   'thinking',
//   'worry'
// ];

// void runModel() {
//   if (sequence.length < 30) return;

//   var input = [sequence];
//   var output =
//       List.filled(1 * actions.length, 0.0).reshape([1, actions.length]);

//   _interpreter?.run(input, output);

//   int predictedIndex = output[0]
//       .indexWhere((val) => val == output[0].reduce((a, b) => a > b ? a : b));

//   print("Predicted Action: ${actions[predictedIndex]}");
// }
