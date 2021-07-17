import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app.dart';
import '../../../color.dart';
import '../../camera.dart';

class imageSelectCard extends StatefulWidget {

  final VoidCallback onTapCamera;
  final VoidCallback onTapGallery;

  const imageSelectCard(
      { required this.onTapCamera,
        required this.onTapGallery});

  @override
  _imageSelectCardState createState() => _imageSelectCardState();
}

class _imageSelectCardState extends State<imageSelectCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: 120 * (deviceWidth / prototypeWidth),
          height: 120 * (deviceWidth / prototypeWidth),
          child: TextButton(
            onPressed: widget.onTapCamera,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.photo_camera,
                  size: 60,
                  color: MangoDisabledColor,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10.0 * deviceWidth / prototypeWidth,
                  ),
                  child: Text('촬영', style: TextStyle(color: MangoBlack)),
                )
              ],
            ),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: MangoDisabledColor),
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        SizedBox(
          width: 120 * (deviceWidth / prototypeWidth),
          height: 120 * (deviceWidth / prototypeWidth),
          child: TextButton(
            onPressed: widget.onTapGallery,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.collections,
                  size: 60,
                  color: MangoDisabledColor,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10.0 * deviceWidth / prototypeWidth,
                  ),
                  child: Text('앨범에서 선택', style: TextStyle(color: MangoBlack)),
                )
              ],
            ),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: MangoDisabledColor),
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}

Future<String> getGalleryImage() async {
  ImagePicker imagePicker = ImagePicker();
  var pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
  return pickedFile!.path;
}
