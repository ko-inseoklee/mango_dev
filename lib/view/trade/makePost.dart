import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/widget/appBar.dart';

class MakePostPage extends StatefulWidget {
  final String title;
  const MakePostPage({Key? key, required this.title}) : super(key: key);

  @override
  _MakePostPageState createState() => _MakePostPageState();
}

class _MakePostPageState extends State<MakePostPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            //TODO: should be changed with new food sections class
            // TestFoodSections(title: '냉장', idx: 0),
            // TestFoodSections(title: '냉동', idx: 1),
            // TestFoodSections(title: '실온', idx: 2)
          ],
        ),
      ),
    );
  }
}
