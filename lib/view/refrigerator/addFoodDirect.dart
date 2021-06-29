import 'package:flutter/material.dart';
import 'package:mangodevelopment/color.dart';
import 'package:mangodevelopment/view/splash.dart';
import 'package:mangodevelopment/view/widget/appBar.dart';
import 'package:mangodevelopment/view/widget/chip.dart';

class AddFoodDirectPage extends StatefulWidget {
  final String title;
  const AddFoodDirectPage({Key? key, required this.title}) : super(key: key);

  @override
  _AddFoodDirectPageState createState() => _AddFoodDirectPageState();
}

class _AddFoodDirectPageState extends State<AddFoodDirectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MangoWhite,
      appBar: MangoAppBar(
        isLeading: true,
        key: widget.key,
        title: widget.title,
      ),
      body: Column(
        children: [
          Container(
            height: 62 * (deviceHeight / prototypeHeight),
            child: Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.all(10 * (deviceHeight / prototypeHeight)),
                  child: Chip(
                    backgroundColor: Orange50,
                    label: Icon(
                      Icons.add,
                      color: Orange400,
                      size: 16.0,
                    ),
                  ),
                ),
                Row(
                  children: [MangoChip(name: '바나나'), MangoChip(name: '바나나 우유')],
                )
              ],
            ),
          ),
          Container(
            height: 7 * (deviceHeight / prototypeHeight),
            color: MangoBehindColor,
          )
        ],
      ),
    );
  }
}
