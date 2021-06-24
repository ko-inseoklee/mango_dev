import 'package:flutter/material.dart';

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
        child: Text('영양 페이지'),
      ),
    );
  }
}
