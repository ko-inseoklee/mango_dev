import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/color.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/view/widget/dialog/deleteDialog.dart';
import 'package:mangodevelopment/view/widget/refrigerator/mangoCard.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';

class FoodsSection extends StatefulWidget {
  final List<Food> foods;
  final String title;

  FoodsSection({Key? key, required this.foods, required this.title})
      : super(key: key);

  @override
  _FoodsSectionState createState() => _FoodsSectionState();
}

class _FoodsSectionState extends State<FoodsSection> {
  late List<Food> showFoods;

  final List<String> dropDownItems = ['전체', '유통기한 임박', '유통기한 만료', '오래된 음식'];

  String selectedValue = '전체';

  bool _isLongPressed = false;

  late RefrigeratorViewModel _refViewModel;

  @override
  Widget build(BuildContext context) {
    showFoods =
        selectedFoods(selectedIdx: dropDownItems.indexOf(selectedValue));

    _refViewModel = Get.find<RefrigeratorViewModel>();

    return Container(
      child: Column(
        children: [
          Container(
            height: ScreenUtil().setHeight(60),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      ScreenUtil().setWidth(14),
                      ScreenUtil().setHeight(11),
                      0,
                      ScreenUtil().setHeight(11)),
                  child: !_isLongPressed
                      ? Text(
                          '전체 ${showFoods.length}개',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(16),
                              color: MangoDisabledColorDark),
                        )
                      : Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isLongPressed = !_isLongPressed;
                                    });
                                  },
                                  child: Text(
                                    '취소',
                                    style: TextStyle(
                                        color: MangoDisabledColorDark,
                                        fontSize: 14.0),
                                  )),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextButton(
                                  onPressed: () {
                                    Get.dialog(DeleteDialog(
                                      onPressed: () async {
                                        await _refViewModel
                                            .deleteFoods(foods: showFoods)
                                            .then((value) => Get.back());
                                      },
                                      deleteAll: true,
                                      foods: showFoods,
                                    ));
                                  },
                                  child: Text(
                                    '모두 삭제',
                                    style: TextStyle(
                                        color: MangoDisabledColorDark,
                                        fontSize: 14.0),
                                  )),
                            ),
                          ],
                        ),
                ),
                Spacer(),
                Container(
                  child: Icon(
                    Icons.filter_alt_outlined,
                  ),
                ),
                Container(
                  width: selectedValue == '전체'
                      ? ScreenUtil().setWidth(100)
                      : ScreenUtil().setWidth(120),
                  padding: EdgeInsets.fromLTRB(0, ScreenUtil().setHeight(11),
                      ScreenUtil().setWidth(14), ScreenUtil().setHeight(11)),
                  child: DropdownButton(
                    isExpanded: true,
                    value: selectedValue,
                    items: dropDownItems
                        .map((e) => DropdownMenuItem(
                            value: e,
                            child: Center(
                              child: Text(
                                e,
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(fontSize: ScreenUtil().setSp(16)),
                              ),
                            )))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value.toString();
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          showFoods.length == 0
              ? Container(
                  padding: EdgeInsets.only(top: 200),
                  child: Text('냉장고가 비었습니다.'),
                )
              : Container(
                  height: ScreenUtil().setHeight(550),
                  padding: EdgeInsets.all(ScreenUtil().setWidth(8)),
                  child: GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: ScreenUtil().setWidth(120) /
                        ScreenUtil().setHeight(185),
                    children: buildCards(foods: showFoods),
                  ),
                ),
        ],
      ),
    );
  }

  List<Widget> buildCards({required List<Food> foods}) {
    return foods.map((e) => buildCard(e)).toList();
  }

  Widget buildCard(Food e) {
    return MangoCard(
      food: e,
      longPressed: () {
        setState(() {
          _isLongPressed = !_isLongPressed;
        });
      },
      isLongPressed: _isLongPressed,
    );
  }

  List<Food> selectedFoods({required int selectedIdx}) {
    switch (selectedIdx) {
      case 1:
        return widget.foods
            .where((element) => element.cardStatus == 2)
            .toList();
      case 2:
        return widget.foods
            .where((element) => element.cardStatus == 1)
            .toList();
      case 3:
        return widget.foods
            .where((element) => element.cardStatus == 3)
            .toList();
      default:
        return widget.foods;
    }
  }
}
