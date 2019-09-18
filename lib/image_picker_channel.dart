import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ImageSource { photos, camera }

String _stringImageSource(ImageSource imageSource) {
  switch (imageSource) {
    case ImageSource.photos:
      return 'photos';
    case ImageSource.camera:
      return 'camera';
  }
  return null;
}

abstract class ImagePicker {
  Future<File> pickImage({ImageSource imageSource});
}

class ImagePickerChannel implements ImagePicker {
  static const platform =
      const MethodChannel('com.musevisions.flutter/imagePicker');

  Future<File> pickImage({ImageSource imageSource}) async {
    final stringImageSource = _stringImageSource(imageSource);
    final result = await platform.invokeMethod('pickImage', stringImageSource);
    if (result is String) {
      return File(result);
    } else if (result is FlutterError) {
      throw result;
    }
    return null;
  }
}
