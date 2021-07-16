import 'package:flutter/material.dart';

import '../../../app.dart';
import 'dialog.dart';

class ImageSelectDialog extends StatefulWidget {
  @override
  _ImageSelectDialogState createState() => _ImageSelectDialogState();
}

class _ImageSelectDialogState extends State<ImageSelectDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Container(
          width: deviceWidth, child: Center(child: Text('프로필 사진 수정'))),
      content: Container(
        height: 150 * (deviceWidth / prototypeWidth),
        child: imageSelectCard(),
      ),
    );
  }
}
