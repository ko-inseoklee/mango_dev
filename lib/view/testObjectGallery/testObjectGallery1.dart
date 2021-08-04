import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/app.dart';
import 'package:mangodevelopment/view/testObjectGallery/testObjectGallery2.dart';

class TestObjectGallery1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Image.asset(
              'images/testObjectGallery/screen1.png',
              width: deviceWidth,
              height: deviceHeight,
              fit: BoxFit.fill,
            ),
            Positioned(
              left: 25,
              bottom: 20,
                child: ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                  width: deviceWidth - 50,
                height: 50 * (deviceHeight/prototypeHeight)
              ),
              child: TextButton(onPressed: (){
                Get.off(TestObjectGallery2());
              }, child: Text('확인', style: TextStyle(color: Colors.black)),
                style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).accentColor
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
