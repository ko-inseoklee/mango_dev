import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mangodevelopment/app.dart';
import 'package:mangodevelopment/test/showFoodViewModel.dart';
import 'package:mangodevelopment/test/testRef.dart';
import 'package:mangodevelopment/view/widget/mangoDivider.dart';
import 'package:mangodevelopment/viewModel/categoryController.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

import '../../color.dart';
import 'addFoodDirect.dart';

List<String> canModifyFoods = [];

class TestRefPage extends StatefulWidget {
  String title;
  TestRefPage({Key? key, required String title}) : title = title;

  @override
  _TestRefPageState createState() => _TestRefPageState();
}

class _TestRefPageState extends State<TestRefPage> {
  late UserViewModel user;

  ShowFoodsController controller = Get.put(new ShowFoodsController());

  TestRefViewModel refrigerator = Get.put(new TestRefViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = Get.find<UserViewModel>();
    refrigerator.loadRefID(rID: user.user.value.refrigeratorID).then((value) {
      print('on init = ${refrigerator.ref.value.rID}');
      controller
          .loadAllFoods(rID: user.user.value.refrigeratorID)
          .then((value) {
        controller.getFoodsLength(rID: refrigerator.ref.value.rID);
        print('on init 실온 == ${controller.foods.value.showRefFoods[3].length}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
              height: 50,
              child: Column(
                children: [
                  Row(
                    children: [
                      Obx(() {
                        return tabView(title: '유통기한별 보기', idx: 0);
                      }),
                      Obx(() {
                        return tabView(title: '한눈에 보기', idx: 1);
                      }),
                      Obx(() {
                        return tabView(title: '카테고리별 보기', idx: 2);
                      }),
                      // tabView(title: '유통기한별 보기', idx: 0),
                      // tabView(title: '한눈에 보기', idx: 1),
                      // tabView(title: '카테고리별 보기', idx: 2),
                    ],
                  ),
                ],
              )),
          Container(
            height: 40,
            child: Obx(() {
              return !controller.foods.value.isModify
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Obx(() {
                            return Text(
                              '전체 ${controller.foods.value.foodsLength} 개',
                              style: Theme.of(context).textTheme.subtitle1,
                            );
                          }),
                        ),
                        Spacer(),
                        Container(
                            child: TextButton(
                          onPressed: () {
                            controller.foldAll(
                                storeType: controller.foods.value.currentTab,
                                isFold: controller.foods.value.allFold);
                          },
                          child: Obx(() {
                            return controller.foods.value.allFold
                                ? Text('모두 펼치기',
                                    style:
                                        Theme.of(context).textTheme.subtitle2)
                                : Text('모두 접기',
                                    style:
                                        Theme.of(context).textTheme.subtitle2);
                          }),
                        )),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextButton(
                                onPressed: () {
                                  controller.changeIsModify();
                                  controller.foldAll(
                                      storeType:
                                          controller.foods.value.currentTab,
                                      isFold: true);
                                },
                                child: Text('선택',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2))),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Obx(() {
                            return Text(
                              '선택 ${controller.foods.value.canModifyFoods.length} 개',
                              style: Theme.of(context).textTheme.subtitle1,
                            );
                          }),
                        ),
                        Spacer(),
                        Container(
                            child: TextButton(
                          onPressed: () async {
                            await controller
                                .deleteFood(
                                    rID: refrigerator.ref.value.rID,
                                    foods:
                                        controller.foods.value.canModifyFoods)
                                .then((value) {
                              controller.clearCanModify();
                            });
                            await controller
                                .getFoodsLength(rID: refrigerator.ref.value.rID)
                                .then((value) {
                              controller.changeIsModify();
                              controller.foldAll(
                                  storeType: controller.foods.value.currentTab,
                                  isFold: controller.foods.value.allFold);
                            });
                          },
                          child: Text('삭제',
                              style: Theme.of(context).textTheme.subtitle2),
                        )),
                        Container(
                            child: TextButton(
                          onPressed: () {},
                          child: Text('수정',
                              style: Theme.of(context).textTheme.subtitle2),
                        )),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextButton(
                                onPressed: () {
                                  controller.changeIsModify();
                                  controller.clearCanModify();
                                },
                                child: Text('취소',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2))),
                      ],
                    );
            }),
          ),
          MangoDivider(),
          Container(
            height: deviceHeight - 237,
            child: ListView(
              children: [
                Obx(() {
                  return controller.foods.value.currentTab == 0
                      ? firstTab()
                      : controller.foods.value.currentTab == 1
                          ? secondTab()
                          : thirdTab();
                })
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tabView({required String title, required int idx}) {
    return Container(
      width: 130,
      height: 40,
      decoration: BoxDecoration(
          border: Border(
              bottom: controller.foods.value.currentTab == idx
                  ? BorderSide(color: Orange700)
                  : BorderSide.none)),
      child: TextButton(
        child: Text(
          title,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
              color: controller.foods.value.currentTab == idx
                  ? Orange700
                  : MangoDisabledColor),
        ),
        onPressed: () {
          controller.changeViewMode(viewMode: idx);
        },
      ),
    );
  }

  Widget firstTab() {
    return Column(children: [
      TestFoodSections(title: '유통기한 경과', idx: 20),
      TestFoodSections(title: '유통기한 7일 이내', idx: 15),
      TestFoodSections(
          title: '구매일로부터 ${user.user.value.roomTempAlarm}일 경과 - 실온', idx: 18),
      TestFoodSections(
          title: '구매일로부터 ${user.user.value.refrigerationAlarm}일 경과 - 냉장',
          idx: 16),
      TestFoodSections(
          title: '구매일로부터 ${user.user.value.frozenAlarm}일 경과 - 냉동', idx: 17),
      TestFoodSections(title: '안심 Zone', idx: 19),
    ]);
  }

  Widget secondTab() {
    return Column(
      children: [
        TestFoodSections(title: '냉장', idx: 0),
        TestFoodSections(title: '냉동', idx: 1),
        TestFoodSections(title: '실온', idx: 2)
      ],
    );
  }

  Widget thirdTab() {
    return Column(
      children: [
        TestFoodSections(title: '과일', idx: 3),
        TestFoodSections(title: '채소', idx: 4),
        TestFoodSections(title: '우유/유제품', idx: 5),
        TestFoodSections(title: '수산물', idx: 6),
        TestFoodSections(title: '곡물', idx: 7),
        TestFoodSections(title: '조미료/양념', idx: 8),
        TestFoodSections(title: '육류', idx: 9),
        TestFoodSections(title: '냉장/냉동식품', idx: 10),
        TestFoodSections(title: '베이커리', idx: 11),
        TestFoodSections(title: '김치/반찬', idx: 12),
        TestFoodSections(title: '즉석식품', idx: 13),
        TestFoodSections(title: '물/음료', idx: 14)
      ],
    );
  }
}

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
  late TestRefViewModel _refrigerator;
  late UserViewModel user;

  @override
  Widget build(BuildContext context) {
    _controller = Get.find<ShowFoodsController>();
    _refrigerator = Get.find<TestRefViewModel>();
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
                      height: 0.1,
                    )
                  : _controller.foods.value.showRefFoods[widget.idx].length == 0
                      ? Container(
                          alignment: Alignment.center,
                          height: 100,
                          child: Text('냉장고가 비었습니다.'),
                        )
                      : Container(
                          width: deviceWidth,
                          height: ((_controller.foods.value
                                          .showRefFoods[widget.idx].length /
                                      3) +
                                  1) *
                              160,
                          child: GridView.count(
                            // count 3,50,60 - 2,45,50
                            crossAxisCount: 3,
                            childAspectRatio: 55 / 70,
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

  List<Widget> _buildFoodCards(
      List<TemporaryFood> foods, BuildContext context) {
    return foods.map((e) => _buildFoodCard(e, context)).toList();
  }

  Widget _buildFoodCard(TemporaryFood food, BuildContext context) {
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

  Widget normalCard(TemporaryFood food, BuildContext context) {
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
                border: Border.all(color: MangoDisabledColorLight, width: 2.0)),
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

  Widget modifyCard(TemporaryFood food, BuildContext context) {
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
                border: Border.all(color: Orange400, width: 2.0)),
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

  Widget shelfOverCard(TemporaryFood food, BuildContext context) {
    return TextButton(
      onPressed: () {
        addModifyCard(fID: food.fId);
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Red200,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: MangoDisabledColorLight, width: 2.0)),
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
            width: 70,
            height: 30,
            child: Text(
              'OVER',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Red500, fontWeight: FontWeight.w700, fontSize: 22.0),
            ),
            left: 5,
            top: 5,
          ),
        ],
      ),
    );
  }

  Widget shelfDDayCard(TemporaryFood food, BuildContext context) {
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
                border: Border.all(color: MangoDisabledColorLight, width: 2.0)),
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
              width: 40,
              height: 30,
              decoration: BoxDecoration(
                  color: Red200, borderRadius: BorderRadius.circular(5)),
              child: Text(
                'D-${food.shelfLife.difference(DateTime.now()).inDays + 1}',
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: Red500, fontWeight: FontWeight.w700, fontSize: 22.0),
              ),
            ),
            left: 5,
            top: 5,
          ),
        ],
      ),
    );
  }

  Widget registStaleCard(TemporaryFood food, BuildContext context) {
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
                border: Border.all(color: Purple200, width: 2.0)),
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
                width: 70,
                height: 30,
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
