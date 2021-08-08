import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangodevelopment/color.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/view/widget/refrigerator/mangoCard.dart';

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

  @override
  Widget build(BuildContext context) {
    showFoods =
        selectedFoods(selectedIdx: dropDownItems.indexOf(selectedValue));

    return Container(
      // height: ScreenUtil().setHeight(200),
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
                  child: Text(
                    '전체 ${showFoods.length}개',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(16),
                        color: MangoDisabledColorDark),
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
          Container(
            height: ScreenUtil().setHeight(550),
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 50 / 50,
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
    return MangoCard(food: e);
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
