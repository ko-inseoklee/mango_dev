import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/view/market/post/addPost.dart';
import 'package:mangodevelopment/view/widget/comingSoon.dart';
import 'package:mangodevelopment/view/widget/dialog/deleteDialog.dart';
import 'package:mangodevelopment/view/widget/dialog/detailDialog.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';
import 'package:mangodevelopment/widgetController/categoryController.dart';

import '../../../color.dart';

class MangoCard extends StatelessWidget {
  final Food food;
  VoidCallback longPressed;
  final bool isLongPressed;
  final bool isPost;

  late RefrigeratorViewModel _refController;

  MangoCard(
      {Key? key,
      required this.food,
      required this.longPressed,
      required this.isLongPressed,
      required this.isPost})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _refController = Get.find<RefrigeratorViewModel>();

    return whichCard(type: food.cardStatus);
  }

  Widget whichCard({required int type}) {
    switch (type) {
      case 1:
        return overCard();
      case 2:
        return dDayCard();
      case 3:
        return staleCard();
      default:
        return normalCard();
    }
  }

  Widget staleCard() {
    return Stack(children: [
      TextButton(
        onLongPress: longPressed,
        onPressed: onPressed(food: food),
        child: Container(
          child: Card(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: MangoDisabledColorLight),
                borderRadius: BorderRadius.circular(10)),
            color: Purple100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'images/category/${categoryImg[translateToKo(food.category)]}',
                    scale: 1.2,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
                  child: Text(
                    food.name,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(8.0, 4.0, 0, 8.0),
                  child: Text(
                      '${DateFormat.yMd().format(food.registrationDay)}일 등록',
                      style: TextStyle(
                          color: Purple500, fontSize: ScreenUtil().setSp(12))),
                )
              ],
            ),
          ),
        ),
      ),
      Positioned(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Purple200, borderRadius: BorderRadius.circular(5.0)),
          width: ScreenUtil().setWidth(62),
          height: ScreenUtil().setHeight(24),
          child: Text(
            'STALE',
            style: TextStyle(
                fontWeight: FontWeight.w700, color: Purple500, fontSize: 18.0),
          ),
        ),
        top: 20,
        left: 20,
      ),
      deleteButton()
    ]);
  }

  Widget overCard() {
    return Stack(children: [
      TextButton(
        onLongPress: longPressed,
        onPressed: onPressed(food: food),
        child: Container(
          child: Card(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: MangoDisabledColorLight),
                borderRadius: BorderRadius.circular(10)),
            color: Red50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'images/category/${categoryImg[translateToKo(food.category)]}',
                    scale: 1.2,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
                  child: Text(
                    food.name,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(8.0, 4.0, 0, 8.0),
                    child: Text(
                        '${DateTime.now().difference(food.alarmDay).inDays}일 지남',
                        style: TextStyle(color: Red500, fontSize: 12.0))),
              ],
            ),
          ),
        ),
      ),
      Positioned(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Red200, borderRadius: BorderRadius.circular(5.0)),
          width: ScreenUtil().setWidth(62),
          height: ScreenUtil().setHeight(24),
          child: Text(
            'OVER',
            style: TextStyle(
                fontWeight: FontWeight.w700, color: Red500, fontSize: 18.0),
          ),
        ),
        top: 20,
        left: 20,
      ),
      deleteButton()
    ]);
  }

  Widget dDayCard() {
    return Stack(children: [
      TextButton(
        onLongPress: longPressed,
        onPressed: onPressed(food: food),
        child: Container(
          child: Card(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: MangoDisabledColorLight),
                borderRadius: BorderRadius.circular(10)),
            color: Red50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'images/category/${categoryImg[translateToKo(food.category)]}',
                    scale: 1.2,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
                  child: Text(
                    food.name,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(8.0, 4.0, 0, 8.0),
                    child: Text(
                        '${food.shelfLife.difference(DateTime.now()).inDays}일 전',
                        style: TextStyle(color: Red500, fontSize: 12.0))),
              ],
            ),
          ),
        ),
      ),
      Positioned(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Red200, borderRadius: BorderRadius.circular(5.0)),
          width: ScreenUtil().setWidth(44),
          height: ScreenUtil().setHeight(24),
          child: Text(
            'D-${food.shelfLife.difference(DateTime.now()).inDays}',
            style: TextStyle(
                fontWeight: FontWeight.w700, color: Red500, fontSize: 18.0),
          ),
        ),
        top: 20,
        left: 20,
      ),
      deleteButton()
    ]);
  }

  Widget normalCard() {
    return Stack(children: [
      TextButton(
        onLongPress: longPressed,
        onPressed: onPressed(food: food),
        child: Card(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: MangoDisabledColorLight),
              borderRadius: BorderRadius.circular(10)),
          color: MangoWhite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'images/category/${categoryImg[translateToKo(food.category)]}',
                  scale: 1.2,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
                child: Text(
                  food.name,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(8.0, 4.0, 0, 8.0),
                child: food.displayType
                    ? Text(
                        '${food.shelfLife.difference(DateTime.now()).inDays}일 전',
                        style: TextStyle(color: Red500, fontSize: 12.0))
                    : Text(
                        '${DateFormat.yMd().format(food.registrationDay)}일 등록',
                        style: TextStyle(
                            color: Purple500,
                            fontSize: ScreenUtil().setSp(12))),
              ),
            ],
          ),
        ),
      ),
      deleteButton(),
    ]);
  }

  Widget deleteButton() {
    return isLongPressed
        ? Positioned(
            top: 2,
            right: 2,
            child: Container(
              width: ScreenUtil().setWidth(35),
              height: ScreenUtil().setHeight(35),
              decoration: BoxDecoration(
                  color: Orange700, borderRadius: BorderRadius.circular(25)),
              child: TextButton(
                onPressed: () {
                  Get.dialog(DeleteDialog(
                      deleteAll: false,
                      food: food,
                      onPressed: () async {
                        _refController.deleteFood(fID: food.fId).then((value) {
                          Get.back();
                        });
                      }));
                },
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    '-',
                    style: TextStyle(
                        color: MangoWhite, fontSize: ScreenUtil().setSp(18)),
                  ),
                ),
              ),
            ))
        : SizedBox(
            height: 0.1,
          );
  }

  VoidCallback onPressed({required Food food}) {
    return isPost
        ? () {
            Get.to(AddPostPage(
              title: '거래품목 등록',
              food: food,
            ));
          }
        : () {
            Get.dialog(DetailDialog(
                food: food,
                onPressed: () async {
                  _refController
                      .updateFood(food: food)
                      .then((value) => Get.back());
                }));
          };
  }
}
