import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../../main.dart';
import 'detail.dart';

class TextAI extends StatefulWidget {
  @override
  _TextAIState createState() => _TextAIState();
}

class _TextAIState extends State<TextAI> {
  late final CameraController _controller;

  void _initializeCamera() async {
    final CameraController cameraController = CameraController(
      cameras[0], //back camera
      // ** 1 is for front camera
      ResolutionPreset.high, //resolution quality of camera
    );
    _controller = cameraController;

    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void initState() {
    _initializeCamera();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // save the taken picture to file system
  // returns the image path
  Future<String?> _takePicture() async {
    if (!_controller.value.isInitialized) {
      print('Controller not initialized');
      return null;
    }

    String? imagePath;

    if (_controller.value.isTakingPicture) {
      print('Processing is in progress..');
      return null;
    }

    try {
      // _controller.setFlashMode(FlashMode.off);
      final XFile file = await _controller.takePicture();
      imagePath = file.path;
      // file.saveTo('/../././././././..../././/././');
    } on CameraException catch (e) {
      print('Camera Exception: $e');
      return null;
    }
    return imagePath;
  }

  //build camera screen UI

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('텍스트 인식 촬영'),
      ),
      body: _controller.value.isInitialized
          ? Stack(
              children: <Widget>[
                CameraPreview(_controller),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.camera),
                      label: Text("Click"),
                      onPressed: () async {
                        // If the returned path is not null, navigate
                        // to the DetailScreen
                        await _takePicture().then((String? path) {
                          print('path = ' + path.toString());
                          if (path != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                  imagePath: path,
                                ),
                              ),
                            );
                          } else {
                            print('Image path not found!');
                          }
                        });
                      },
                    ),
                  ),
                )
              ],
            )
          : Container(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
