import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/home.dart';

import '../../app.dart';

class GuidePage extends StatefulWidget {
  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  final imgWidth = 311.0;
  final imgHeight = 485.0;

  final prototypeDotSize = 12.0;
  final prototypeDotPadding = ScreenUtil().setWidth(7.5);

  int index = 0;

  List<String> imgList = [
    'images/guide/guide1.png',
    'images/guide/guide2.png',
    'images/guide/guide3.png',
    'images/guide/guide4.png',
    'images/guide/guide5.png'
  ];

  @override
  Widget build(BuildContext context) {
    //TODO. auth 필요한 사항??
    // var _auth = Provider.of<Authentication>(context);
    // context.read<UserViewModel>().findUserSnapshot(_auth.user.uid);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          SizedBox(height: deviceHeight * 0.1,),
          Expanded(
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: PageController(initialPage: 0),
                onPageChanged: (int index){
                setState(() {
                  this.index = index;
                });
                },
              itemCount: imgList.length,
              itemBuilder: (BuildContext context, int index) {
                return  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          imgList[index],
                          width: ScreenUtil().setWidth(imgWidth),
                          height: ScreenUtil().setHeight(imgHeight),
                        ),
                      ],
                    ),
                );
            }
            ),
          ),
          SizedBox(child: scrollProgress(index)),
          index == imgList.length - 1
              ? ElevatedButton(
              onPressed: () {
                Get.offAll(HomePage(title: 'hi'));
              },
              child: Text('MANGO 시작하기'))
              : TextButton(
              onPressed: () {
                Get.offAll(HomePage(title: 'hi'));
              },
              child: Text('skip')),
          SizedBox(height: deviceHeight * 0.1),
        ],
      ),
    );
  }

  Widget scrollProgress(int idx) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        idx == 0 ? activeIcon() : inactiveIcon(),
        idx == 1 ? activeIcon() : inactiveIcon(),
        idx == 2 ? activeIcon() : inactiveIcon(),
        idx == 3 ? activeIcon() : inactiveIcon(),
        idx == 4 ? activeIcon() : inactiveIcon()
      ],
    );
  }

  Widget activeIcon() {
    return Padding(
        padding:
            EdgeInsets.fromLTRB(prototypeDotPadding, 0, prototypeDotPadding, 0),
        child: Icon(
          Icons.fiber_manual_record,
          size: prototypeDotSize * (deviceWidth / prototypeWidth),
          color: Theme.of(context).accentColor,
        ));
  }

  Widget inactiveIcon() {
    return Padding(
      padding:
          EdgeInsets.fromLTRB(prototypeDotPadding, 0, prototypeDotPadding, 0),
      child: Icon(
        Icons.fiber_manual_record,
        size: prototypeDotSize * (deviceWidth / prototypeWidth),
        color: Theme.of(context).unselectedWidgetColor,
      ),
    );
  }
}
