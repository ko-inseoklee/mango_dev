import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../app.dart';
import '../../../color.dart';

class imageSelectCard extends StatefulWidget {
  @required
  final IconData icon;
  @required
  final String title;
  @required
  final VoidCallback onTapOK;

  const imageSelectCard(
      {required this.icon, required this.title, required this.onTapOK});

  @override
  _imageSelectCardState createState() => _imageSelectCardState();
}

class _imageSelectCardState extends State<imageSelectCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenUtil().setWidth(98),
      height: ScreenUtil().setHeight(114),
      child: TextButton(
        onPressed: widget.onTapOK,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              size: ScreenUtil().setSp(40),
              color: MangoDisabledColor,
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                top: 5.0 * deviceWidth / prototypeWidth,
              ),
              child: Text(widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: MangoBlack, fontSize: ScreenUtil().setSp(14))),
            )
          ],
        ),
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: MangoDisabledColor),
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

Future<String> getGalleryImage() async {
  ImagePicker imagePicker = ImagePicker();
  var pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

  return pickedFile!.path;
}
