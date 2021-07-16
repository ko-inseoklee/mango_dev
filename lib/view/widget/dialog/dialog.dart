import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app.dart';
import '../../../color.dart';
import '../../camera.dart';

class mangoDialog extends StatefulWidget {
  final String dialogTitle;
  final String contentText;
  final VoidCallback onTapOK;
  @required
  final bool hasOK;

  const mangoDialog(
      { //Key key,
      required this.dialogTitle,
      required this.contentText,
      required this.onTapOK,
      required this.hasOK});

  @override
  _mangoDialogState createState() => _mangoDialogState();
}

class _mangoDialogState extends State<mangoDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.dialogTitle),
      content: Text(widget.contentText),
      actions: [
        widget.hasOK
            ? FlatButton(
                child: Text('확인', style: TextStyle(color: Orange400)),
                onPressed: widget.onTapOK,
                onLongPress: () => Navigator.pop(context))
            : Text(""),
        FlatButton(
          child: Text('취소', style: TextStyle(color: MangoDisabledColor)),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}

void comingSoon(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return mangoDialog(
            dialogTitle: "Coming soon", hasOK: false, contentText: "준비 중입니다.", onTapOK: () {  });
      });
}

Widget imageSelectCard(){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      ButtonTheme(
        // colorScheme: Theme.of(context).colorScheme,
        height: 120 * (deviceWidth / prototypeWidth),
        minWidth: 120 * (deviceWidth / prototypeWidth),
        child: FlatButton(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: MangoDisabledColor),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
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
                child:
                Text('촬영', style: TextStyle(color: MangoBlack)),
              )
            ],
          ),
          onPressed: () {
            Get.to(CameraPage());
          },
        ),
      ),
      ButtonTheme(
        // colorScheme: Theme.of(context).colorScheme,
        height: 120 * (deviceWidth / prototypeWidth),
        minWidth: 120 * (deviceWidth / prototypeWidth),
        child: FlatButton(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: MangoDisabledColor),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
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
                child: Text('앨범에서 선택',
                    style: TextStyle(color: MangoBlack)),
              )
            ],
          ),
          onPressed: () {
            Get.back();
          },
        ),
      )
    ],
  );
}
