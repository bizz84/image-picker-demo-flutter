import 'dart:io';

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
      home: new MyHomePage(title: 'Image Picker Demo'),
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

  File _imageFile;

  void captureImage(ImageSource captureMode) async {
    try {
      var imageFile = await _imagePicker.pickImage(captureMode: captureMode);
      setState(() {
        _imageFile = imageFile;
      });
    }
    catch (e) {
      print(e);
    }
  }

  Widget _buildImage() {
    if (_imageFile != null) {
      return new Image.file(_imageFile);
    } else {
      return new Text('Take an image to start', style: new TextStyle(fontSize: 18.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Column(
        children: [
          new Expanded(child: new Center(child: _buildImage())),
          _buildButtons()
        ]
      ),
    );
  }


  Widget _buildButtons() {
    return new ConstrainedBox(
      constraints: BoxConstraints.expand(height: 80.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildActionButton(new Key('retake'), 'Photos', () => captureImage(ImageSource.photos)),
          _buildActionButton(new Key('upload'), 'Camera', () => captureImage(ImageSource.camera)),
        ]
      ));
  }

  Widget _buildActionButton(Key key, String text, Function onPressed) {
    return new Expanded(
      child: new FlatButton(
          key: key,
          child: new Text(text, style: new TextStyle(fontSize: 20.0)),
          shape: new RoundedRectangleBorder(),
          color: Colors.blueAccent,
          textColor: Colors.white,
          onPressed: onPressed),
    );
  }
}


