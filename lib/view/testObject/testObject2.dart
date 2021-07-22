import 'package:flutter/material.dart';

import '../../app.dart';

class TestObject2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Image.asset(
            'images/testObject/screen4.png',
            width: deviceWidth,
            height: deviceHeight,
            fit: BoxFit.fill,
          ),
        ));
  }
}
