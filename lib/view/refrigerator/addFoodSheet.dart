import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/recognize/barcodeFromGallery.dart';
import 'package:mangodevelopment/view/widget/dialog/imageSelectCard.dart';

import '../../color.dart';
import 'addFoodDirect.dart';
import 'addFoodQuick.dart';

class AddFoodSheet extends StatefulWidget {
  const AddFoodSheet({Key? key}) : super(key: key);

  @override
  _AddFoodSheetState createState() => _AddFoodSheetState();
}

class _AddFoodSheetState extends State<AddFoodSheet> {
  bool isBarcode = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: MangoWhite,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
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
            child: Text(
              '냉장고 품목 등록',
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            '원하는 방법을 통해\n냉장고에 편리하게 식자재를 등록하세요.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              imageSelectCard(
                  icon: Icons.flash_on,
                  title: 'Quick\n채우기',
                  onTapOK: () {
                    Get.back();
                    Get.dialog(AddFoodQuickPage());
                  }),
              imageSelectCard(
                  icon: Icons.photo_camera,
                  title: '자동 인식\n채우기',
                  onTapOK: () {
                    Get.to(BarcodeFromGallery());
                  }),
              imageSelectCard(
                  icon: Icons.mode_edit,
                  title: '직접\n채우기',
                  onTapOK: () {
                    Get.off(() => AddFoodDirectPage(title: '냉장고 품목 등록'));
                  }),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: MangoBehindColor,
              ),
              onPressed: () => Get.back(),
              child: Text('취소', style: TextStyle(color: MangoBlack)),
            ),
          ),
        ],
      ),
    );
  }
}
