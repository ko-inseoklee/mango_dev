import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/view/widget/refrigerator/mangoCard.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';
import 'package:mangodevelopment/widgetController/categoryController.dart';
import 'package:uuid/uuid.dart';

import '../../color.dart';
import 'barcodeFromGallery.dart';

class RecognizedResult extends StatefulWidget {
  final Map<String, dynamic> result;
  const RecognizedResult({Key? key,required this.result}) : super(key: key);

  @override
  _RecognizedResultState createState() => _RecognizedResultState();
}

class _RecognizedResultState extends State<RecognizedResult> {

  List<String> barcodeResults = [];
  late Food result;
  RefrigeratorViewModel refrigerator = Get.find<RefrigeratorViewModel>();

  @override
  void initState() {
    super.initState();
    result = new Food(fId: Uuid().v4(), rId: refrigerator.ref.value.rID, index: 0, status: true, name: widget.result['row'][0]['PRDLST_NM'].toString(), num: 1, category: "베이커리/과자", method: 0, displayType: true, shelfLife: DateTime.now(), registrationDay: DateTime.now(), alarmDate: DateTime.now(), cardStatus: -1);

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.all(Radius.circular(20.0))),
    title: Container(
    width: ScreenUtil().setWidth(300),
    child: Padding(padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(0), ScreenUtil().setHeight(15), 0, 0),
    child: Text('품목을 찾았습니다.'))),
      content:
      Container(
        height: ScreenUtil().setHeight(220),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0,ScreenUtil().setHeight(20),0,ScreenUtil().setHeight(8)),
              decoration: BoxDecoration(
                border: Border.all(color: Orange400,width: 2.0),
                borderRadius: BorderRadius.circular(15.0)
              ),
              height: ScreenUtil().setHeight(160),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border(right: BorderSide(width: 1, color: MangoDisabledColorLight)),
                        // borderRadius: BorderRadius.only(15.0)
                    ),
                    padding: EdgeInsets.only(right: ScreenUtil().setWidth(4)),
                    height: ScreenUtil().setHeight(100),
                    width: ScreenUtil().setWidth(80),
                    margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
                    child: Image.asset(
                      'images/category/${categoryImg[translateToKo(result.category)]}',
                      scale: 1.0,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                    // alignment: Alignment.center,
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('품목명: ',style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: ScreenUtil().setSp(15)),),
                            Text('카테고리: ',style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: ScreenUtil().setSp(15),)),
                            Text('유통기한: ',style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: ScreenUtil().setSp(15))),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('${result.name}',style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: ScreenUtil().setSp(14))),
                            Text('${result.category}',style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: ScreenUtil().setSp(12))),
                            Text('${result.alarmDay.day}일 후',style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: ScreenUtil().setSp(14))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(alignment: Alignment.centerLeft,child: Text('* 식품 안전나라 DB에 등록된 권장 유통기한입니다.',style: Theme.of(context).textTheme.caption!.copyWith(color: MangoErrorColor, fontSize: 10.0),))

          ],
        ),
      ),
      actions: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.fromLTRB(8,0,0,8),
          child: Text('* 바코드 인식이 잘못되었다면?',style: Theme.of(context).textTheme.caption!.copyWith( fontSize: 10.0)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                width: ScreenUtil().setWidth(130),
                height: ScreenUtil().setHeight(45),
                decoration: BoxDecoration(
                    color: MangoDisabledColorLight,
                    borderRadius: BorderRadius.circular(5.0)),
                child: TextButton(
                    onPressed: () {
                      Get.back();
                      Get.dialog(BarcodeFromGallery());
                    },
                    child: Text(
                      '재촬영',
                      style: TextStyle(color: MangoBlack),
                    ))),
            Container(
                width: ScreenUtil().setWidth(130),
                height: ScreenUtil().setHeight(45),
                decoration: BoxDecoration(
                    color: Orange400,
                    borderRadius: BorderRadius.circular(5.0)),
                child: TextButton(
                    onPressed: () async {
                      List<Food> foods = [];
                      foods.add(result);
                      await refrigerator.addFoods(foods).then((value) => Get.back());
                    },
                    child: Text(
                      '등록',
                      style: TextStyle(color: MangoBlack),
                    ))),
          ],
        )
      ],
      actionsPadding: EdgeInsets.only(bottom: 6.0),
    );
  }
}
