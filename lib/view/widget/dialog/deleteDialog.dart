import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mangodevelopment/color.dart';
import 'package:mangodevelopment/model/food.dart';

class DeleteDialog extends StatefulWidget {
  Food? food;
  List<Food>? foods;
  final bool deleteAll;
  VoidCallback onPressed;
  DeleteDialog(
      {Key? key,
        this.food,
        this.foods,
        required this.onPressed,
        required this.deleteAll})
      : super(key: key);

  @override
  _DeleteDialogState createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      content: Container(
        width: ScreenUtil().setWidth(332),
        height: ScreenUtil().setHeight(180),
        child: Column(
          children: [
            widget.deleteAll
                ? Padding(
              padding: EdgeInsets.fromLTRB(0, ScreenUtil().setHeight(30),
                  0, ScreenUtil().setHeight(8)),
              child: Text(
                '모두 삭제하시겠습니까?',
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14)),
              ),
            )
                : Padding(
              padding: EdgeInsets.fromLTRB(0, ScreenUtil().setHeight(30),
                  0, ScreenUtil().setHeight(8)),
              child: Text(
                '정말 삭제하시겠습니까?',
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14)),
              ),
            ),
            widget.deleteAll
                ? Padding(
              padding: EdgeInsets.all(ScreenUtil().setSp(16)),
              child: Text(
                '${widget.foods![0].name} 등 ${widget.foods!.length} 품목',
                style: TextStyle(
                    color: MangoDisabledColorDark, fontSize: ScreenUtil().setSp(14)),
              ),
            )
                : Padding(
              padding: EdgeInsets.all(ScreenUtil().setSp(16)),
              child: Text(
                '${widget.food!.name} ${widget.food!.number}개, 등록일 ${DateFormat.yMd().format(widget.food!.registrationDay)}',
                style: TextStyle(
                    color: MangoDisabledColorDark, fontSize: ScreenUtil().setSp(14)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    width: ScreenUtil().setWidth(120),
                    height: ScreenUtil().setHeight(50),
                    decoration: BoxDecoration(
                        color: MangoDisabledColorLight,
                        borderRadius: BorderRadius.circular(5.0)),
                    child: TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          '취소',
                          style: TextStyle(color: MangoBlack),
                        ))),
                Container(
                    width: ScreenUtil().setWidth(120),
                    height: ScreenUtil().setHeight(50),
                    decoration: BoxDecoration(
                        color: Orange400,
                        borderRadius: BorderRadius.circular(5.0)),
                    child: TextButton(
                        onPressed: widget.onPressed,
                        child: Text(
                          '삭제',
                          style: TextStyle(color: MangoBlack),
                        ))),
              ],
            )
          ],
        ),
      ),
      contentPadding: EdgeInsets.only(bottom: 0),
    );
  }
}