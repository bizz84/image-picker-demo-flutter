//
//  FlutterChannelManager.swift
//  Runner
//
//  Created by Andrea Bizzotto on 18/04/2018.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

import UIKit

class ImagePicker: UIImagePickerController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  var handler: ((_ image: UIImage?) -> Void)?
  
  convenience init(sourceType: UIImagePickerControllerSourceType) {
    self.init()
    self.sourceType = sourceType
    self.delegate = self
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    handler?(info[UIImagePickerControllerOriginalImage] as? UIImage)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    handler?(nil)
  }
}

class FlutterChannelManager: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  let channel: FlutterMethodChannel
  unowned let flutterViewController: FlutterViewController
  
  init(flutterViewController: FlutterViewController) {
    
    self.flutterViewController = flutterViewController
    channel = FlutterMethodChannel(name: "com.musevisions.camera/capture", binaryMessenger: flutterViewController)
  }
  
  func setup() {
    channel.setMethodCallHandler { (call, result) in
      switch call.method {
      case "takePicture":
        //call.arguments // check input
        let imagePicker = ImagePicker(sourceType: .photoLibrary)
        imagePicker.handler = { image in
          imagePicker.dismiss(animated: true, completion: nil)
          result(self.flutterImageResult(image))
        }
        self.flutterViewController.present(imagePicker, animated: true, completion: nil)
      default:
        break
      }
    }
  }
  
  private func flutterImageResult(_ image: UIImage?) -> [String: Any] {
    guard let image = image else {
      return ["error": "user did cancel"]
    }
    guard let data = FlutterStandardTypedData(image: image) else {
      return ["error": "could not read image"]
    }
    return [
      "data": data,
      "width": image.size.width,
      "height": image.size.height,
      "scale": image.scale
    ]
  }
}

extension FlutterStandardTypedData {
  convenience init?(image: UIImage) {
    guard let data = UIImageJPEGRepresentation(image, 1.0) else {
      return nil
    }
    self.init(bytes: data)
  }
}

