import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mangodevelopment/view/refrigerator/addFoodDirect.dart';
import 'dart:io';

import '../../../app.dart';
import '../../../color.dart';

class imageSelectCard extends StatefulWidget {
  // final VoidCallback onTapCamera;
  // final VoidCallback onTapGallery;

  const imageSelectCard();

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
          width: ScreenUtil().setWidth(72),
          height: ScreenUtil().setHeight(96),
          child: TextButton(
            onPressed: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.flash_on,
                  size: ScreenUtil().setSp(30),
                  color: MangoDisabledColor,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    top: 10.0 * deviceWidth / prototypeWidth,
                  ),
                  child: Text('Quick         채우기',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: MangoBlack, fontSize: ScreenUtil().setSp(12))),
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
          width: ScreenUtil().setWidth(72),
          height: ScreenUtil().setHeight(96),
          child: TextButton(
            onPressed: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.photo_camera,
                  size: ScreenUtil().setSp(30),
                  color: MangoDisabledColor,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    top: 10.0 * deviceWidth / prototypeWidth,
                  ),
                  child: Text('자동 인식    채우기',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: MangoBlack, fontSize: ScreenUtil().setSp(12))),
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
          width: ScreenUtil().setWidth(72),
          height: ScreenUtil().setHeight(96),
          child: TextButton(
            onPressed: () {
              Get.off(() => AddFoodDirectPage(title: '냉장고 품목 등록'));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.mode_edit,
                  size: ScreenUtil().setSp(30),
                  color: MangoDisabledColor,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    top: 10.0 * deviceWidth / prototypeWidth,
                  ),
                  child: Text('직접 채우기',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: MangoBlack, fontSize: ScreenUtil().setSp(12))),
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
