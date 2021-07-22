import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/app.dart';

class TestObjectGallery3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Image.asset(
              'images/testObjectGallery/screen3.png',
              width: deviceWidth,
              height: deviceHeight,
              fit: BoxFit.fill,
            ),
            Positioned(
              bottom: 0,
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                  width: deviceWidth,
                  height: 100,
                ),
                child: TextButton(
                  onPressed: () {
                    Get.back();
                    Get.snackbar('등록 완료', '품목을 등록이 완료되었습니다.');
                  },
                  child: Text(''),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
