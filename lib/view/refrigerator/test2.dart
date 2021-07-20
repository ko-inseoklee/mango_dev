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

class TestRefPage extends StatefulWidget {
  String title;
  TestRefPage({Key? key, required String title}) : title = title;

  @override
  _TestRefPageState createState() => _TestRefPageState();
}

class _TestRefPageState extends State<TestRefPage> {
  int currentTab = 0;

  late UserViewModel user;

  ShowFoodsController controller = Get.put(new ShowFoodsController());

  TestRefViewModel refrigerator = Get.put(new TestRefViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = Get.find<UserViewModel>();
    refrigerator.loadRefID(rID: user.user.value.refrigeratorID).then((value) {
      print('on init = ${user.user.value.refrigeratorID}');
    });
  }

  @override
  Widget build(BuildContext context) {
    controller.getFoodsLength(rID: refrigerator.ref.value.rID);
    controller.loadAllFoods(rID: refrigerator.ref.value.rID);

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
                      tabView(title: '유통기한별 보기', idx: 0),
                      tabView(title: '한눈에 보기', idx: 1),
                      tabView(title: '카테고리별 보기', idx: 2),
                    ],
                  ),
                ],
              )),
          Container(
            height: 40,
            child: Row(
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
                    switch (currentTab) {
                      case 1:
                        print('1');
                        break;
                      case 2:
                        print('2');
                        break;
                      default:
                        print('0');
                    }
                  },
                  child: Text('모두 펼치기'),
                )),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('선택')),
              ],
            ),
          ),
          MangoDivider(),
          Container(
            height: deviceHeight - 237,
            child: ListView(
              children: [
                currentTab == 0
                    ? firstTab()
                    : currentTab == 1
                        ? secondTab()
                        : thirdTab(),
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
              bottom: currentTab == idx
                  ? BorderSide(color: Orange700)
                  : BorderSide.none)),
      child: TextButton(
        child: Text(
          title,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
              color: currentTab == idx ? Orange700 : MangoDisabledColor),
        ),
        onPressed: () {
          setState(() {
            currentTab = idx;
          });
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

class ShowWithShelf extends StatelessWidget {
  ShowWithShelf({Key? key}) : super(key: key);

  late UserViewModel user;
  late TestRefViewModel refrigerator;
  late ShowFoodsController foods;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class TestFoodSections extends StatelessWidget {
  String title;
  int idx;

  TestFoodSections({Key? key, required String title, required int idx})
      : title = title,
        idx = idx;

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
                // switch (idx) {
                //   case 0:
                //     await _controller.loadFoodsWithStoreType(
                //         rID: _refrigerator.ref.value.rID, storeType: idx);
                //     break;
                //   case 1:
                //     await _controller.loadFoodsWithStoreType(
                //         rID: _refrigerator.ref.value.rID, storeType: idx);
                //     break;
                //   case 2:
                //     await _controller.loadFoodsWithStoreType(
                //         rID: _refrigerator.ref.value.rID, storeType: idx);
                //     break;
                //   case 15:
                //     await _controller.loadFoodsWithShelfDDay(
                //         rID: _refrigerator.ref.value.rID);
                //     break;
                //   case 16:
                //     await _controller.loadFoodsWithRefRegister(
                //       rID: _refrigerator.ref.value.rID,
                //     );
                //     break;
                //   case 17:
                //     await _controller.loadFoodsWithFroRegister(
                //       rID: _refrigerator.ref.value.rID,
                //     );
                //     break;
                //   case 18:
                //     await _controller.loadFoodsWithRTRegister(
                //       rID: _refrigerator.ref.value.rID,
                //     );
                //     break;
                //   case 19:
                //     await _controller.loadFoodsNormal(
                //         rID: _refrigerator.ref.value.rID);
                //     break;
                //   case 20:
                //     await _controller.loadFoodsWithShelfOver(
                //         rID: _refrigerator.ref.value.rID);
                //     break;
                //   default:
                //     await _controller.loadFoodsWithCategory(
                //         rID: _refrigerator.ref.value.rID,
                //         idx: idx,
                //         category: title);
                // }
                // _controller.addFoods(
                //     food: _controller.foods.value.showRefFoods[idx], idx: idx);
                _controller.changeBool(
                    isFold: !_controller.foods.value.showInOnceIsFolds[idx],
                    idx: idx);
                // if (_controller.foods.value.showInOnceIsFolds[idx]) {
                //   _controller.clearFoods(idx: idx);
                // }
              },
              child: Row(
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(12.0, 8.0, 0, 8.0),
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.headline6,
                      )),
                  Spacer(),
                  Obx(() {
                    return Icon(
                      _controller.foods.value.showInOnceIsFolds[idx]
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
              child: _controller.foods.value.showInOnceIsFolds[idx]
                  ? SizedBox(
                      height: 0.1,
                    )
                  : _controller.foods.value.showRefFoods[idx].length == 0
                      ? Container(
                          alignment: Alignment.center,
                          height: 100,
                          child: Text('냉장고가 비었습니다.'),
                        )
                      : Container(
                          height: ((_controller.foods.value.showRefFoods[idx]
                                          .length /
                                      3) +
                                  1) *
                              160,
                          child: GridView.count(
                            // count 3,50,60 - 2,45,50
                            crossAxisCount: 3,
                            childAspectRatio: 55 / 70,
                            children: _buildFoodCards(
                                _controller.foods.value.showRefFoods[idx],
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
    int registerRef = user.user.value.refrigerationAlarm;
    int registerFro = user.user.value.frozenAlarm;
    int registerRT = user.user.value.roomTempAlarm;

    return TextButton(
      onPressed: () {},
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: food.displayType
                    ? food.shelfLife.difference(DateTime.now()).inDays <= 0
                        ? Red200
                        : MangoWhite
                    : food.method == 0
                        ? DateTime.now()
                                    .difference(food.registrationDay)
                                    .inDays >
                                registerRef
                            ? Purple100
                            : MangoWhite
                        : food.method == 1
                            ? DateTime.now()
                                        .difference(food.registrationDay)
                                        .inDays >
                                    registerFro
                                ? Purple100
                                : MangoWhite
                            : DateTime.now()
                                        .difference(food.registrationDay)
                                        .inDays >
                                    registerRT
                                ? Purple100
                                : MangoWhite,
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
            child: !food.displayType
                ? food.method == 0
                    ? DateTime.now().difference(food.registrationDay).inDays >
                            registerRef
                        ? Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Purple100,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Purple200)),
                            child: Text(
                              'STALE',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                      color: Purple500,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 22.0),
                            ))
                        : Text('')
                    : food.method == 1
                        ? DateTime.now()
                                    .difference(food.registrationDay)
                                    .inDays >
                                registerFro
                            ? Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Purple100,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Purple200)),
                                child: Text(
                                  'STALE',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                          color: Purple500,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 22.0),
                                ))
                            : Text('')
                        : DateTime.now()
                                    .difference(food.registrationDay)
                                    .inDays >
                                registerRT
                            ? Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Purple100,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Purple200)),
                                child: Text(
                                  'STALE',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                          color: Purple500,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 22.0),
                                ))
                            : Text('')
                : food.shelfLife.difference(DateTime.now()).inDays <= 0
                    ? Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Red200,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Orange700)),
                        child: Text(
                          'OVER',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  color: Red500,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22.0),
                        ))
                    : food.shelfLife.difference(DateTime.now()).inDays <= 7
                        ? Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Red200,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              'D-${food.shelfLife.difference(DateTime.now()).inDays + 1}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                      color: Red500,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 22.0),
                            ),
                          )
                        : Container(),
            left: 5,
            top: 5,
          ),
        ],
      ),
    );
  }
}
