import 'package:flutter/material.dart';

import '../../app.dart';

class TestObject4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Image.asset(
            'images/testObject/screen5.png',
            width: deviceWidth,
            height: deviceHeight,
          ),
        ));
  }
}
