import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/analyze/textAI.dart';

class NutritionPage extends StatefulWidget {
  final String title;

  const NutritionPage({Key? key, required this.title}) : super(key: key);

  @override
  _NutritionPageState createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: InkWell(
          child: Text('영양 페이지'),
          onTap: () {
            Get.to(TextAI());
          },
        ),
      ),
    );
  }
}
