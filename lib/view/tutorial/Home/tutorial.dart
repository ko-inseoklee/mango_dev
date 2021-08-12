import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TutorialPage extends StatefulWidget {
  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  int state = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        child: Image.asset(
          'images/tutorial/tut$state.png',
          width: ScreenUtil().setWidth(375),
          height: ScreenUtil().setHeight(812),
        ),
        onTap: () {
          if (state == 1) {
            setState(() {
              state = 2;
            });
          } else if (state == 2) {
            setState(() {
              state = 3;
            });
          } else {
            setState(() {
              state = 1;
            });
          }
        },
      ),
    );
  }
}
