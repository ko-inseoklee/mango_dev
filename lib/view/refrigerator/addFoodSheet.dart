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
              height: 30 * (deviceWidth / prototypeWidth),
            ),
            //TODO. onTapGallery needed!
            imageSelectCard(
                // onTapGallery: () {
                //   Get.back();
                //   Get.dialog(AlertDialog(
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.all(Radius.circular(20.0))),
                //     content: Container(
                //       width: deviceWidth,
                //       height: ScreenUtil().setHeight(300),
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Spacer(
                //             flex: 2,
                //           ),
                //           Image.asset(
                //             'images/testObjectGallery/AIrefIcon.png',
                //             width: 250 * (deviceWidth / prototypeWidth),
                //             height: 250 * (deviceWidth / prototypeWidth),
                //           ),
                //           Spacer(
                //             flex: 1,
                //           ),
                //           Container(
                //             child: Text(
                //                 'MANGO를 사용하면 사진 이용하여\n식품을 손쉽게 등록할 수 있습니다.'
                //                 '\n\n시작하려면 사진을 선택하시고, 강조 표시된 영역을 탭하여'
                //                 '\n이미지에 있는 식품을 탭하여 냉장고로 넣어보세요.',
                //                 style: Theme.of(context).textTheme.caption,
                //                 textAlign: TextAlign.center),
                //           ),
                //           Spacer(
                //             flex: 1,
                //           ),
                //           ConstrainedBox(
                //             constraints:
                //                 BoxConstraints.tightFor(width: deviceWidth),
                //             child: TextButton(
                //               onPressed: () {
                //                 Get.off(TestObjectGallery1());
                //               },
                //               child: Text('확인',
                //                   style: TextStyle(color: Colors.black)),
                //               style: TextButton.styleFrom(
                //                   backgroundColor: Theme.of(context).accentColor),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ));
                // },
                // onTapCamera: () {
                //   if (isBarcode == true) {
                //     Get.off(TextAI());
                //   } else {
                //     Get.back();
                //     Get.dialog(AlertDialog(
                //       shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(20.0))),
                //       content: Container(
                //         width: deviceWidth,
                //         height: 450 * (deviceWidth / prototypeWidth),
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Spacer(
                //               flex: 2,
                //             ),
                //             Image.asset(
                //               'images/testObject/AIref.png',
                //               width: 250 * (deviceWidth / prototypeWidth),
                //               height: 250 * (deviceWidth / prototypeWidth),
                //             ),
                //             Spacer(
                //               flex: 1,
                //             ),
                //             Container(
                //               child: Text(
                //                   'MANGO를 사용하면 카메라를 이용하여 \n식품을 손쉽게 등록할 수 있습니다.'
                //                   '\n\n처음에 일치하는 식품이 인식되지 않으면, \n식품 근처로 이동하거나 카메라를 조준해주세요.',
                //                   style: Theme.of(context).textTheme.caption,
                //                   textAlign: TextAlign.center),
                //             ),
                //             Spacer(
                //               flex: 1,
                //             ),
                //             ConstrainedBox(
                //               constraints:
                //                   BoxConstraints.tightFor(width: deviceWidth),
                //               child: TextButton(
                //                 onPressed: () {
                //                   Get.off(TestObject1());
                //                 },
                //                 child: Text('확인',
                //                     style: TextStyle(color: Colors.black)),
                //                 style: TextButton.styleFrom(
                //                     backgroundColor:
                //                         Theme.of(context).accentColor),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ));
                //   }
                // },
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
