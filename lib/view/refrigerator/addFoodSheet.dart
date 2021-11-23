import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/analyze/textAI.dart';

import 'package:mangodevelopment/view/refrigerator/addFoodDirect.dart';
import 'package:mangodevelopment/view/testObject/testObject1.dart';
import 'package:mangodevelopment/view/testObjectGallery/testObjectGallery1.dart';
import 'package:mangodevelopment/view/widget/dialog/imageSelectCard.dart';

import '../../app.dart';
import '../../color.dart';
import '../camera.dart';

class AddFoodSheet extends StatefulWidget {
  const AddFoodSheet({Key? key}) : super(key: key);

  @override
  _AddFoodSheetState createState() => _AddFoodSheetState();
}

class _AddFoodSheetState extends State<AddFoodSheet> {
  bool isBarcode = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Container(
        width: deviceWidth,
        child: Container(
          alignment: Alignment.center,
          child: Text(
            '냉장고 품목 등록',
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ),
      content: Container(
        height: ScreenUtil().setHeight(300),
        child: Column(
          children: [
            Text(
              '원하는 방법을 통해',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            Text(
              '냉장고를 편리하게 식자재를 등록하세요.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(40),
            ),
            //TODO. onTapGallery needed!
            imageSelectCard(),
            Container(
              height: ScreenUtil().setHeight(40),
            ),
            ButtonTheme(
              // colorScheme: Theme.of(context).colorScheme,
              buttonColor: MangoBehindColor,
              minWidth: deviceWidth,
              child: FlatButton(
                color: MangoBehindColor,
                child: Text('취소', style: TextStyle(color: MangoBlack)),
                onPressed: () {
                  Get.back();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
