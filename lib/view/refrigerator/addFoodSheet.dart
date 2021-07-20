import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/analyze/textAI.dart';

import 'package:mangodevelopment/view/refrigerator/addFoodDirect.dart';
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Text(
                '냉장고 품목 등록',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            ButtonTheme(
              minWidth: 30,
              // colorScheme: Theme.of(context).colorScheme,
              buttonColor: MangoBehindColor,
              child: FlatButton(
                color: MangoBehindColor,
                child: Text('직접입력',
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontWeight: FontWeight.w500)),
                onPressed: () {
                  Get.off(() => AddFoodDirectPage(title: '냉장고 품목 등록'));
                },
              ),
            ),
          ],
        ),
      ),
      content: Container(
        height: 350 * (deviceWidth / prototypeWidth),
        child: Column(
          children: [
            Text(
              '영수증 또는 실제 모습을 촬영해주시면',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            Text(
              '자동으로 냉장고에 등록해 드립니다.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            SizedBox(
              height: 30 * (deviceWidth / prototypeWidth),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FlatButton(
                  color: isBarcode ? MangoWhite : MangoBehindColor,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: isBarcode ? Orange400 : MangoDisabledColor),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text('영수증', style: TextStyle(color: MangoBlack)),
                  onPressed: () {
                    setState(() {
                      isBarcode = true;
                    });
                  },
                ),
                FlatButton(
                  color: !isBarcode ? MangoWhite : MangoBehindColor,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: !isBarcode ? Orange400 : MangoDisabledColor),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text('사물인식', style: TextStyle(color: MangoBlack)),
                  onPressed: () {
                    setState(() {
                      isBarcode = false;
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: 30 * (deviceWidth / prototypeWidth),
            ),
            //TODO. onTapGallery needed!
            imageSelectCard(
              onTapGallery: () {},
              onTapCamera: () {
                Get.off(TextAI());
              },
            ),
            Container(
              height: 40 * (deviceHeight / prototypeHeight),
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
