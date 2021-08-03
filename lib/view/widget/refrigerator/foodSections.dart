import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/widgetController/showFoodViewModel.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';
import 'package:mangodevelopment/view/trade/makePostInfo.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';
import 'package:mangodevelopment/widgetController/categoryController.dart';

import '../../../color.dart';
import '../mangoDivider.dart';

class TestFoodSections extends StatefulWidget {
  String title;
  int idx;

  TestFoodSections({Key? key, required String title, required int idx})
      : title = title,
        idx = idx;

  @override
  _TestFoodSectionsState createState() => _TestFoodSectionsState();
}

class _TestFoodSectionsState extends State<TestFoodSections> {
  late ShowFoodsController _controller;
  late RefrigeratorViewModel _refrigerator;
  late UserViewModel user;

  @override
  Widget build(BuildContext context) {
    _controller = Get.find<ShowFoodsController>();
    _refrigerator = Get.find<RefrigeratorViewModel>();
    user = Get.find<UserViewModel>();

    return Container(
      child: Column(
        children: [
          TextButton(
              onPressed: () async {
                _controller.changeBool(
                    isFold:
                        !_controller.foods.value.showInOnceIsFolds[widget.idx],
                    idx: widget.idx);
              },
              child: Row(
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(12.0, 8.0, 0, 8.0),
                      child: Text(
                        widget.title,
                        style: Theme.of(context).textTheme.headline6,
                      )),
                  Spacer(),
                  Obx(() {
                    return Icon(
                      _controller.foods.value.showInOnceIsFolds[widget.idx]
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                      color: MangoBlack,
                      size: 26,
                    );
                  }),
                ],
              )),
          Obx(() {
            return Container(
              child: _controller.foods.value.showInOnceIsFolds[widget.idx]
                  ? SizedBox(
                      height: ScreenUtil().setHeight(0.1),
                    )
                  : _controller.foods.value.showRefFoods[widget.idx].length == 0
                      ? Container(
                          alignment: Alignment.bottomCenter,
                          height: ScreenUtil().setHeight(150),
                          child: Column(
                            children: [
                              SizedBox(
                                height: ScreenUtil().setHeight(20),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: ScreenUtil().setHeight(4)),
                                height: ScreenUtil().setHeight(50),
                                child: Image.asset('images/login/logo.png'),
                              ),
                              Container(child: Text('냉장고가 비었습니다. 품목을 추가하세요!')),
                            ],
                          ),
                        )
                      : Container(
                          width: ScreenUtil().setWidth(375),
                          height: (((_controller.foods.value
                                              .showRefFoods[widget.idx].length /
                                          3) +
                                      1) *
                                  ScreenUtil().setHeight(157)) +
                              ScreenUtil().setHeight(25),
                          child: GridView.count(
                            // count 3,50,60 - 2,45,50
                            crossAxisCount: 3,
                            childAspectRatio: ScreenUtil().setWidth(108) /
                                ScreenUtil().setHeight(157),
                            children: _buildFoodCards(
                                _controller
                                    .foods.value.showRefFoods[widget.idx],
                                context),
                          ),
                        ),
            );
          }),
          MangoDivider(),
        ],
      ),
    );
  }

  List<Widget> _buildFoodCards(List<Food> foods, BuildContext context) {
    return foods.map((e) => _buildFoodCard(e, context)).toList();
  }

  Widget _buildFoodCard(Food food, BuildContext context) {
    if (_controller.foods.value.isModify && food.isModify)
      return modifyCard(food, context);
    else if (food.shelfOver)
      return shelfOverCard(food, context);
    else if (food.shelfDDay)
      return shelfDDayCard(food, context);
    else if (food.registerRTAbnormal ||
        food.registerFroAbnormal ||
        food.registerRefAbnormal)
      return registStaleCard(food, context);
    else
      return normalCard(food, context);
  }

  Widget normalCard(Food food, BuildContext context) {
    return TextButton(
      onPressed: () {
        addModifyCard(fID: food.fId);
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: MangoWhite,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: MangoDisabledColorLight,
                    width: ScreenUtil().setWidth(2.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                    'images/category/${categoryImg[translateToKo(food.category)]}'),
                Container(
                    padding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 6.0),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          food.name,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Spacer(),
                        Text(
                          food.number.toString() + '개',
                          style:
                              Theme.of(context).textTheme.subtitle2!.copyWith(),
                        )
                      ],
                    )),
                Container(
                  padding: EdgeInsets.only(left: 12.0),
                  alignment: Alignment.centerLeft,
                  child: food.displayType
                      ? Text('${DateFormat.yMd().format(food.shelfLife)}일 까지',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Red500, fontSize: 12.0))
                      : Text(
                          '${DateFormat.yMd().format(food.registrationDay)}일 등록',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Purple500, fontSize: 12.0)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget modifyCard(Food food, BuildContext context) {
    return TextButton(
      onPressed: () {
        addModifyCard(fID: food.fId);
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Orange200,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: Orange400, width: ScreenUtil().setWidth(2.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                    'images/category/${categoryImg[translateToKo(food.category)]}'),
                Container(
                    padding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 6.0),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          food.name,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Spacer(),
                        Text(
                          food.number.toString() + '개',
                          style:
                              Theme.of(context).textTheme.subtitle2!.copyWith(),
                        )
                      ],
                    )),
                Container(
                  padding: EdgeInsets.only(left: 12.0),
                  alignment: Alignment.centerLeft,
                  child: food.displayType
                      ? Text('${DateFormat.yMd().format(food.shelfLife)}일 까지',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Red500, fontSize: 12.0))
                      : Text(
                          '${DateFormat.yMd().format(food.registrationDay)}일 등록',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Purple500, fontSize: 12.0)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget shelfOverCard(Food food, BuildContext context) {
    return TextButton(
      onPressed: () {
        if (Get.currentRoute == '/MakePostPage') {
          Get.to(MakePostInfo(), arguments: food);
        } else {
          addModifyCard(fID: food.fId);
        }
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Red200,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: MangoDisabledColorLight,
                    width: ScreenUtil().setWidth(2.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                    'images/category/${categoryImg[translateToKo(food.category)]}'),
                Container(
                    padding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 6.0),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          food.name,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Spacer(),
                        Text(
                          food.number.toString() + '개',
                          style:
                              Theme.of(context).textTheme.subtitle2!.copyWith(),
                        )
                      ],
                    )),
                Container(
                  padding: EdgeInsets.only(left: 12.0),
                  alignment: Alignment.centerLeft,
                  child: food.displayType
                      ? Text('${DateFormat.yMd().format(food.shelfLife)}일 까지',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Red500, fontSize: 12.0))
                      : Text(
                          '${DateFormat.yMd().format(food.registrationDay)}일 등록',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Purple500, fontSize: 12.0)),
                ),
              ],
            ),
          ),
          Positioned(
            width: ScreenUtil().setWidth(62),
            height: ScreenUtil().setHeight(24),
            child: Text(
              'OVER',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Red500,
                  fontWeight: FontWeight.w900,
                  fontSize: ScreenUtil().setSp(20)),
            ),
            left: ScreenUtil().setWidth(9),
            top: ScreenUtil().setHeight(8.0),
          ),
        ],
      ),
    );
  }

  Widget shelfDDayCard(Food food, BuildContext context) {
    return TextButton(
      onPressed: () {
        addModifyCard(fID: food.fId);
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: MangoWhite,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: MangoDisabledColorLight,
                    width: ScreenUtil().setWidth(2.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                    'images/category/${categoryImg[translateToKo(food.category)]}'),
                Container(
                    padding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 6.0),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          food.name,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Spacer(),
                        Text(
                          food.number.toString() + '개',
                          style:
                              Theme.of(context).textTheme.subtitle2!.copyWith(),
                        )
                      ],
                    )),
                Container(
                  padding: EdgeInsets.only(left: 12.0),
                  alignment: Alignment.centerLeft,
                  child: Text('${DateFormat.yMd().format(food.shelfLife)}일 까지',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: Red500, fontSize: 12.0)),
                ),
              ],
            ),
          ),
          Positioned(
            child: Container(
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(44),
              height: ScreenUtil().setHeight(24),
              decoration: BoxDecoration(
                  color: Red200, borderRadius: BorderRadius.circular(5)),
              child: Text(
                'D-${food.shelfLife.difference(DateTime.now()).inDays + 1}',
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: Red500,
                    fontWeight: FontWeight.w700,
                    fontSize: ScreenUtil().setSp(20)),
              ),
            ),
            left: 5,
            top: 5,
          ),
        ],
      ),
    );
  }

  Widget registStaleCard(Food food, BuildContext context) {
    return TextButton(
      onPressed: () {
        addModifyCard(fID: food.fId);
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Purple100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: Purple200, width: ScreenUtil().setWidth(2.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                    'images/category/${categoryImg[translateToKo(food.category)]}'),
                Container(
                    padding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 6.0),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          food.name,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Spacer(),
                        Text(
                          food.number.toString() + '개',
                          style:
                              Theme.of(context).textTheme.subtitle2!.copyWith(),
                        )
                      ],
                    )),
                Container(
                  padding: EdgeInsets.only(left: 12.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                      '${DateFormat.yMd().format(food.registrationDay)}일 등록',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: Purple500, fontSize: 12.0)),
                ),
              ],
            ),
          ),
          Positioned(
            child: Container(
                alignment: Alignment.center,
                width: ScreenUtil().setWidth(71),
                height: ScreenUtil().setHeight(24.0),
                decoration: BoxDecoration(
                  color: Purple100,
                ),
                child: Text('STALE',
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Purple500,
                        fontWeight: FontWeight.w700,
                        fontSize: 22.0))),
            left: 5,
            top: 5,
          ),
        ],
      ),
    );
  }

  addModifyCard({required String fID}) {
    _controller.changeCanModify(fID: fID, idx: widget.idx);
  }
}
