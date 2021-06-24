import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/refrigerator/test.dart';

import '../widget/appBar.dart';

class RefrigeratorPage extends StatefulWidget {
  final String title;

  const RefrigeratorPage({Key? key, required this.title}) : super(key: key);

  @override
  _RefrigeratorPageState createState() => _RefrigeratorPageState();
}

class _RefrigeratorPageState extends State<RefrigeratorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MangoAppBar(
        title: '나의 냉장고',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text('냉장고 페이지'),
            )
            // Text(_.tabIndex.toString()),
            // TextButton(
            //     onPressed: () =>
            //         print("here in homepage : ${_.tabIndex.value}"),
            //     child: Text('find currentIdx')),
            // TextButton(
            //     onPressed: () async =>
            //         await _.FindRefrigeratorSnapshot('1234'),
            //     child: Text('fetch ref'))
          ],
        ),
      ),
    );
  }
}
