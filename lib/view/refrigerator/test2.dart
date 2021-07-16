import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mangodevelopment/app.dart';
import 'package:mangodevelopment/test/showFoods.dart';
import 'package:mangodevelopment/test/testRef.dart';
import 'package:mangodevelopment/view/widget/mangoDivider.dart';
import 'package:mangodevelopment/viewModel/categoryController.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

import '../../color.dart';
import 'addFoodDirect.dart';

class TestRefPage extends StatelessWidget {
  TestRefPage({Key? key}) : super(key: key);

  late UserViewModel _user;
  ShowFoodsController _controller = Get.put(new ShowFoodsController());
  TestRefViewModel _refrigerator = Get.put(new TestRefViewModel());

  @override
  Widget build(BuildContext context) {
    _user = Get.find<UserViewModel>();
    _refrigerator.loadRefID(rID: _user.user.value.refrigeratorID);

    return Scaffold(
      appBar: AppBar(
        title: Text('테스트 페이지'),
      ),
      body: ListView(
        children: [
          TestFoodSections(title: '냉장', idx: 0),
          TestFoodSections(title: '냉동', idx: 1),
          TestFoodSections(title: '실온', idx: 2)
        ],
      ),
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
                await _controller.loadFoodsWithStoreType(
                    rID: _refrigerator.ref.value.rID, storeType: idx);

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
                          height:
                              _controller.foods.value.showRefFoods[idx].length *
                                  100,
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
                  : Text('${DateFormat.yMd().format(food.registrationDay)}일 등록',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: Purple500, fontSize: 12.0)),
            ),
          ],
        ),
      ),
    );
  }
}
//
// class FoodSections extends StatefulWidget {
//   String title;
//   bool isFold;
//   bool isSelected;
//   VoidCallback onPressed;
//   Function(String) onSelectParam;
//   List<TemporaryFood> foods;
//   FoodSections(
//       {Key? key,
//         required this.title,
//         required this.isFold,
//         required this.isSelected,
//         required this.onPressed,
//         required this.onSelectParam,
//         required this.foods})
//       : super(key: key);
//
//   @override
//   _FoodSectionsState createState() => _FoodSectionsState();
// }
//
// class _FoodSectionsState extends State<FoodSections> {
//   List<String> _tempFoodsID = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           TextButton(
//             onPressed: widget.onPressed,
//             child: Row(
//               children: [
//                 Container(
//                     padding: EdgeInsets.fromLTRB(12.0, 8.0, 0, 8.0),
//                     child: Text(
//                       widget.title,
//                       style: Theme.of(context).textTheme.headline6,
//                     )),
//                 Spacer(),
//                 Icon(
//                   widget.isFold
//                       ? Icons.keyboard_arrow_down
//                       : Icons.keyboard_arrow_up,
//                   color: MangoBlack,
//                   size: 26,
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             child: widget.isFold
//                 ? SizedBox(
//               height: 0.1,
//             )
//                 : widget.foods.length == 0
//                 ? Container(
//               alignment: Alignment.center,
//               height: 100,
//               child: Text('냉장고가 비었습니다.'),
//             )
//                 : Container(
//               height: 150 * ((widget.foods.length / 3) + 1),
//               child: GridView.count(
//                 crossAxisCount: 3,
//                 childAspectRatio: 50 / 60,
//                 children: _buildFoodCards(widget.foods),
//               ),
//             ),
//           ),
//           MangoDivider(),
//         ],
//       ),
//     );
//   }
//
//   List<Widget> _buildFoodCards(List<TemporaryFood> foods) {
//     return foods.map((e) => _buildFoodCard(e)).toList();
//   }
//
