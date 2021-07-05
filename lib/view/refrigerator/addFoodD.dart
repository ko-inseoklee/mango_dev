import 'package:flutter/material.dart';
import 'package:mangodevelopment/app.dart';
import 'package:mangodevelopment/view/widget/appBar.dart';

import '../../color.dart';

class AddFoodD extends StatefulWidget {
  final String title;
  const AddFoodD({Key? key, required this.title}) : super(key: key);

  @override
  _AddFoodDState createState() => _AddFoodDState();
}

class _AddFoodDState extends State<AddFoodD> {
  List<TemporaryFood> foods = [];

  int currentIdx = 0;
  int maxIdx = 0;

  @override
  Widget build(BuildContext context) {
    maxIdx = foods.length;
    // foods.clear();
    // currentIdx = 0;
    // maxIdx = 0;

    return Scaffold(
      appBar: MangoAppBar(
        title: widget.title,
        isLeading: true,
      ),
      body: Column(
        children: [
          Container(
            height: 80 * (deviceHeight / prototypeHeight),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                  child: ActionChip(
                      backgroundColor: Orange50,
                      label: Icon(
                        Icons.add,
                        size: 18.0,
                        color: Orange700,
                      ),
                      onPressed: () {
                        setState(() {
                          addChip();
                        });
                      }),
                ),
                Expanded(
                    child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _buildChips(foods: foods),
                ))
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                InfoBody(currentIdx),
                TextButton(
                    onPressed: () {
                      setState(() {
                        clearChip();
                      });
                    },
                    child: Text('clear chips'))
              ],
            ),
          ),
          Container(
            height: 80 * (deviceHeight / prototypeHeight),
            child: Text('registration'),
          )
        ],
      ),
    );
  }

  void addChip() {
    foods.add(new TemporaryFood(
        index: maxIdx,
        name: 'name$maxIdx',
        num: 0,
        category: '',
        method: 0,
        shelfLife: DateTime.now(),
        registrationDay: DateTime.now()));

    print(maxIdx);
    print(currentIdx);
  }

  List<Widget> _buildChips({required List<TemporaryFood> foods}) {
    return foods.map((e) => _buildChip(food: e)).toList();
  }

  Widget _buildChip({required TemporaryFood food}) {
    return Wrap(
      direction: Axis.vertical,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(
              4.0 * deviceWidth / prototypeWidth,
              16.0 * deviceWidth / prototypeWidth,
              4.0 * deviceWidth / prototypeWidth,
              16.0 * deviceWidth / prototypeWidth),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), border: Border.all()),
          child: TextButton(
              child: Text(
                food.name,
                overflow: TextOverflow.clip,
              ),
              onPressed: () {
                setState(() {
                  currentIdx = food.idx;
                });
              }),
        )
      ],
    );
  }

  //TODO: parameter has to be changed token of food name.
  Widget InfoBody(int idx) {
    if (foods.length == 0) {
      return Text('blank');
    } else {
      return Text('${foods[idx].name}');
    }
  }

  void clearChip() {
    foods.clear();
    maxIdx = foods.length;
    currentIdx = 0;
  }
}

class TemporaryFood {
  int idx;
  String name;
  int number;
  String category;
  int method;
  DateTime shelfLife;
  DateTime registrationDay;

  TemporaryFood(
      {required int index,
      required String name,
      required int num,
      required String category,
      required int method,
      required DateTime shelfLife,
      required DateTime registrationDay})
      : idx = index,
        name = name,
        number = num,
        category = category,
        method = method,
        shelfLife = shelfLife,
        registrationDay = registrationDay;
  String get getName => name;
}
