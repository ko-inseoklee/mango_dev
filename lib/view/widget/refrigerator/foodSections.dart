import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/view/widget/mangoCard.dart';

class FoodsSection extends StatelessWidget {
  final List<Food> foods;
  final String title;
  FoodsSection({Key? key, required this.foods, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(200),
      child: Column(
        children: [
          Container(
            height: ScreenUtil().setHeight(30),
            child: Row(
              children: [Text(title), Text('${foods.length}개')],
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(170),
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 50 / 50,
              children: buildCards(foods: foods),
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
}
