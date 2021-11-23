import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/market/post/selectPost.dart';
import 'package:mangodevelopment/view/widget/comingSoon.dart';

import '../../../color.dart';

class AddPostDialog extends StatefulWidget {
  const AddPostDialog({Key? key}) : super(key: key);

  @override
  _AddPostDialogState createState() => _AddPostDialogState();
}

class _AddPostDialogState extends State<AddPostDialog> {
  bool isBarcode = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: MangoWhite, borderRadius: BorderRadius.circular(20)),
      height: ScreenUtil().setHeight(400),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(160),
                ScreenUtil().setHeight(20.0), ScreenUtil().setWidth(160), 0),
            height: ScreenUtil().setHeight(10.0),
            decoration: BoxDecoration(
                color: MangoDisabledColor,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
          ),
          Container(
            // width: deviceWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    '거래 품목 등록하기',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Get.to(selectPostFoodPage(
                    title: '거래 품목 선택',
                  ));
                },
                child: Container(
                  alignment: Alignment.center,
                  width: ScreenUtil().setWidth(150),
                  height: ScreenUtil().setHeight(160),
                  decoration: BoxDecoration(
                      border: Border.all(color: MangoDisabledColor),
                      borderRadius: BorderRadius.circular(8.0),
                      color: MangoWhite),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.kitchen_outlined,
                        size: ScreenUtil().setSp(50),
                        color: MangoDisabledColor,
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(10),
                      ),
                      Text(
                        '냉장고에서 선택',
                        style: TextStyle(
                            color: MangoBlack,
                            fontSize: ScreenUtil().setSp(20.0)),
                      )
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.dialog(ComingSoonDialog());
                },
                child: Container(
                  alignment: Alignment.center,
                  width: ScreenUtil().setWidth(150),
                  height: ScreenUtil().setHeight(160),
                  decoration: BoxDecoration(
                      border: Border.all(color: MangoDisabledColor),
                      borderRadius: BorderRadius.circular(8.0),
                      color: MangoWhite),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.kitchen_outlined,
                        size: ScreenUtil().setSp(50),
                        color: MangoDisabledColor,
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(10),
                      ),
                      Text(
                        '거래물품 바로 등록',
                        style: TextStyle(
                            color: MangoBlack,
                            fontSize: ScreenUtil().setSp(18.0)),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
                onPressed: () {
                  Get.back();
                },
                style: TextButton.styleFrom(
                  backgroundColor: MangoBehindColor,
                ),
                child: Text('취소', style: TextStyle(color: MangoBlack))),
          ),
        ],
      ),
    );
  }
}
