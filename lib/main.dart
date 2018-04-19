import 'dart:async';

import 'package:flutter/material.dart';
import 'image_picker_channel.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  ImagePicker _imagePicker = new ImagePickerChannel();

  Map<dynamic, dynamic> _imageData;

  void captureImage(ImageCaptureMode captureMode) async {
    var imageData = await _imagePicker.captureImage(captureMode: captureMode);
    setState(() {
      _imageData = imageData;
    });
  }

  Widget _buildImage() {
    if (_imageData != null) {
      if (_imageData['data'] != null) {
        return new Image.memory(
            _imageData['data'],
            scale: _imageData['scale'],
            width: _imageData['width'],
            height: _imageData['height']
        );
      } else {
        return new Text(_imageData['error']);
      }
    } else {
      return new Text('Take an image to start');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: _buildImage(),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => captureImage(ImageCaptureMode.photos),
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


