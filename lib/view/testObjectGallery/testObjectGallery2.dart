import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/testObject/testObject3.dart';
import 'package:mangodevelopment/view/testObjectGallery/testObjectGallery3.dart';

import '../../app.dart';

class TestObjectGallery2 extends StatefulWidget {
  @override
  _TestObjectGallery2State createState() => _TestObjectGallery2State();
}

class _TestObjectGallery2State extends State<TestObjectGallery2> {

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
            'images/testObjectGallery/screen2.png',
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
    Get.off(TestObjectGallery3(),transition: Transition.fadeIn);
    return this;
  }
}
