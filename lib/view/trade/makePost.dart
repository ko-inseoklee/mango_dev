import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/app.dart';
import 'package:mangodevelopment/test/showFoodViewModel.dart';
import 'package:mangodevelopment/view/widget/appBar.dart';

class MakePostPage extends StatefulWidget {
  final String title;
  const MakePostPage({Key? key, required this.title}) : super(key: key);

  @override
  _MakePostPageState createState() => _MakePostPageState();
}

class _MakePostPageState extends State<MakePostPage> {
  late ShowFoodsController _showFoodsController;

  @override
  Widget build(BuildContext context) {
    _showFoodsController = Get.find<ShowFoodsController>();

    return Scaffold(
      appBar: MangoAppBar(title: widget.title, isLeading: true),
      body: Center(
        child: Text(widget.title),
      ),
    );
  }
}
