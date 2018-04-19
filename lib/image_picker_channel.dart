import 'dart:async';

import 'package:flutter/services.dart';

enum ImageCaptureMode {
  photos,
  camera
}

String _stringCaptureMode(ImageCaptureMode captureMode) {
  switch (captureMode) {
    case ImageCaptureMode.photos:
      return 'photos';
    case ImageCaptureMode.camera:
      return 'camera';
  }
}

abstract class ImagePicker {
  Future<dynamic> captureImage({ImageCaptureMode captureMode});
}

class ImagePickerChannel implements ImagePicker {

  static const platform = const MethodChannel('com.musevisions.camera/capture');

  Future<dynamic> captureImage({ImageCaptureMode captureMode}) async {

    try {
      var captureModeString = _stringCaptureMode(captureMode);
      return await platform.invokeMethod('takePicture', captureModeString);
    } on PlatformException catch (e) {
      print(e);
    }
  }
}