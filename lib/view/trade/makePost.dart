import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/widgetController/showFoodViewModel.dart';
import 'package:mangodevelopment/view/widget/appBar.dart';
import 'package:mangodevelopment/view/widget/refrigerator/foodSections.dart';
import '../refrigerator/refrigerator.dart';

class MakePostPage extends StatefulWidget {
  final String title;
  const MakePostPage({Key? key, required this.title}) : super(key: key);

  @override
  _MakePostPageState createState() => _MakePostPageState();
}

class _MakePostPageState extends State<MakePostPage> {
  late ShowFoodsController _showFoodsController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _showFoodsController = Get.find<ShowFoodsController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MangoAppBar(title: widget.title, isLeading: true),
      body: Center(
        child: ListView(
          children: [
            TextButton(
                onPressed: () {
                  print(Get.currentRoute);
                },
                child: Text('call current nav')),
            TestFoodSections(title: '냉장', idx: 0),
            TestFoodSections(title: '냉동', idx: 1),
            TestFoodSections(title: '실온', idx: 2)
          ],
        ),
      ),
    );
  }
}
