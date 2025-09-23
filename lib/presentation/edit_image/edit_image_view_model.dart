// import 'package:flutter/material.dart';
// import 'package:crop_your_image/crop_your_image.dart';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
//
// class PhotoEditorViewModel extends ChangeNotifier {
//   final cropController = CropController();
//
//   double aspectRatio = 0; // 0 = free
//   Uint8List? croppedBytes;
//
//   void setAspectRatio(double ratio) {
//     aspectRatio = ratio;
//     notifyListeners();
//   }
//
//   Future<void> onCropped(CropResult result) async {
//     // Достаём байты из CropResult
//     final byteData = await result.uiImage.toByteData(format: ui.ImageByteFormat.png);
//     if (byteData != null) {
//       croppedBytes = byteData.buffer.asUint8List();
//       notifyListeners();
//     }
//   }
// }
