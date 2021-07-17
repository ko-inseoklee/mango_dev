import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mangodevelopment/app.dart';
import 'package:mangodevelopment/test/showFoods.dart';
import 'package:mangodevelopment/test/testRef.dart';
import 'package:mangodevelopment/view/widget/mangoDivider.dart';
import 'package:mangodevelopment/viewModel/categoryController.dart';
import 'package:mangodevelopment/viewModel/foodViewModel.dart';
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
  Widget build(BuildContext context) {
    user = Get.find<UserViewModel>();
    refrigerator.loadRefID(rID: user.user.value.refrigeratorID);

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
            height: deviceHeight - 200,
            child: ListView(
              children: [
                currentTab == 0
                    ? Container(
                        child: Text('유통기한별 보기'),
                      )
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

class TestFoodSections extends StatelessWidget {
  String title;
  int idx;

  TestFoodSections({Key? key, required String title, required int idx})
      : title = title,
        idx = idx;

  late ShowFoodsController _controller;
  late TestRefViewModel _refrigerator;

  @override
  Widget build(BuildContext context) {
    _controller = Get.find<ShowFoodsController>();
    _refrigerator = Get.find<TestRefViewModel>();

    return Container(
      child: Column(
        children: [
          TextButton(
              onPressed: () async {
                if (idx < 3)
                  await _controller.loadFoodsWithStoreType(
                      rID: _refrigerator.ref.value.rID, storeType: idx);
                else
                  await _controller.loadFoodsWithCategory(
                      rID: _refrigerator.ref.value.rID,
                      idx: idx,
                      category: title);

                _controller.addFoods(
                    food: _controller.foods.value.showRefFoods[idx], idx: idx);
                _controller.changeBool(
                    isFold: !_controller.foods.value.showInOnceIsFolds[idx],
                    idx: idx);
                if (_controller.foods.value.showInOnceIsFolds[idx]) {
                  _controller.clearFoods(idx: idx);
                }
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
                              150,
                          child: GridView.count(
                            crossAxisCount: 3,
                            childAspectRatio: 50 / 60,
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
    return TextButton(
      onPressed: () {},
      child: Card(
        child: Stack(
          children: [
            Container(
              color: food.status
                  ? food.shelfLife.difference(DateTime.now()).inDays <= 0
                      ? Red200
                      : MangoWhite
                  : MangoWhite,
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
                          Text(food.number.toString() + '개')
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
              width: 60,
              height: 25,
              child: !food.status
                  ? Container(child: Text(''))
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
                                    color: Red500, fontWeight: FontWeight.w700),
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
                                        fontWeight: FontWeight.w700),
                              ),
                            )
                          : Container(),
              left: 5,
              top: 5,
            ),
          ],
        ),
      ),
    );
  }
}
