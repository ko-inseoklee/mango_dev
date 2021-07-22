import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/testObject/testObject2.dart';
import 'package:mangodevelopment/view/testObject/testObject3.dart';
import 'package:mangodevelopment/view/testObject/testObject4.dart';
import 'package:mangodevelopment/view/testObject/testObject5.dart';

import '../../app.dart';

class TestObject1 extends StatefulWidget {
  @override
  _TestObject1State createState() => _TestObject1State();
}

class _TestObject1State extends State<TestObject1> {

  @override
  void initState() {
    super.initState();
    Get.putAsync(() => SettingService().init());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Image.asset(
            'images/testObject/screen2.png',
            width: deviceWidth,
            height: deviceHeight,
            fit: BoxFit.fill,
          ),
        ));
  }
}

class SettingService extends GetxService{
  Future<SettingService> init() async{
    await 3.delay();
    Get.off(TestObject2(),transition: Transition.fadeIn);
    await 4.delay();
    Get.off(TestObject3(),transition: Transition.fadeIn);
    await 4.delay();
    Get.off(TestObject4(),transition: Transition.fadeIn);
    await 5.delay();
    Get.off(TestObject5(),transition: Transition.fadeIn);
    return this;
  }
}
