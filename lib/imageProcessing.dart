// import 'dart:typed_data';
// import 'package:camera/camera.dart';
// //import 'dart:typed_data'; // For Uint8List and WriteBuffer
// import 'package:flutter/foundation.dart'; // For WriteBuffer
// import 'package:google_mlkit_commons/google_mlkit_commons.dart'; // For InputImageMetadata
// //import 'package:camera/camera.dart'; // For CameraImage
// import 'package:flutter/material.dart'; // For Size

// void processCameraImage(CameraImage image) {
//   InputImage inputImage = convertCameraImageToInputImage(image, 90);

//   // You can now pass this inputImage to a model for predictions
//   print("InputImage processed successfully");
// }

// InputImage convertCameraImageToInputImage(CameraImage image, int rotation) {
//   final WriteBuffer buffer = WriteBuffer();
//   for (Plane plane in image.planes) {
//     buffer.putUint8List(plane.bytes);
//   }
//   final Uint8List bytes = buffer.done().buffer.asUint8List();

//   // final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
//   final Size imageSize = Size(
//     image.width.toDouble(),
//     image.height.toDouble(),
//   ); // Keep this
//   final int imageWidth = image.width.toInt();
//   final int imageHeight = image.height.toInt();

//   final InputImageMetadata metadata = InputImageMetadata(
//     size: Size(imageWidth.toDouble(), imageHeight.toDouble()),
//     rotation:
//         InputImageRotationValue.fromRawValue(rotation) ??
//         InputImageRotation.rotation0deg,
//     format: InputImageFormat.yuv420,
//     bytesPerRow: image.planes[0].bytesPerRow,
//   );

//   return InputImage.fromBytes(bytes: bytes, metadata: metadata);
// }
