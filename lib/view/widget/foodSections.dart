import 'package:flutter/material.dart';
import 'package:mangodevelopment/view/refrigerator/addFoodDirect.dart';
import 'package:mangodevelopment/viewModel/categoryController.dart';

import '../../color.dart';

class FoodSections extends StatefulWidget {
  final String title;
  bool isFold;
  final VoidCallback onPressed;
  List<TemporaryFood> foods;
  FoodSections(
      {Key? key,
      required this.title,
      required this.isFold,
      required this.onPressed,
      required this.foods})
      : super(key: key);

  @override
  _FoodSectionsState createState() => _FoodSectionsState();
}

class _FoodSectionsState extends State<FoodSections> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextButton(
            onPressed: widget.onPressed,
            child: Row(
              children: [
                Container(
                    padding: EdgeInsets.fromLTRB(12.0, 8.0, 0, 8.0),
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.headline6,
                    )),
                Spacer(),
                Icon(
                  widget.isFold
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                  color: MangoBlack,
                  size: 26,
                ),
              ],
            ),
          ),
          Container(
            child: widget.isFold
                ? SizedBox(
                    height: 0.1,
                  )
                : widget.foods.length == 0
                    ? Container(
                        alignment: Alignment.center,
                        height: 100,
                        child: Text('냉장고가 비었습니다.'),
                      )
                    : Container(
                        height: 200,
                        child: GridView.count(
                          crossAxisCount: 3,
                          childAspectRatio: 50 / 60,
                          children: _buildFoodCards(widget.foods),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFoodCards(List<TemporaryFood> foods) {
    return foods.map((e) => _buildFoodCard(e)).toList();
  }

  Widget _buildFoodCard(TemporaryFood food) {
    return Card(
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
                ? Text('${food.shelfLife}일 까지',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Red500))
                : Text('${food.registrationDay}일 등록',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Purple500)),
          ),
        ],
      ),
    );
  }
}
