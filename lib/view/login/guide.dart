import 'package:flutter/material.dart';

import '../../app.dart';

class guidePage extends StatefulWidget {
  @override
  _guidePageState createState() => _guidePageState();
}

class _guidePageState extends State<guidePage> {
  final imgWidth = 311.0;
  final imgHeight = 485.0;

  final prototypeDotSize = 12.0;
  final prototypeDotPadding = 7.5 * (deviceWidth / prototypeWidth);

  List<String> imgList = [
    'images/guide/guide1.png',
    'images/guide/guide2.png',
    'images/guide/guide3.png',
    'images/guide/guide4.png',
    'images/guide/guide5.png'
  ];

  @override
  Widget build(BuildContext context) {
    //var _auth = Provider.of<Authentication>(context);
    //context.read<UserViewModel>().findUserSnapshot(_auth.user.uid);

    return PageView.builder(
      scrollDirection: Axis.horizontal,
      controller: PageController(initialPage: 0),
      itemCount: imgList.length,
      itemBuilder: (BuildContext context, int index) {
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imgList[index],
                  width: imgWidth * (deviceWidth / prototypeWidth),
                  height: imgHeight * (deviceWidth / prototypeWidth),
                ),
                scrollProgress(index),
                index == imgList.length - 1
                    ? ButtonTheme(
                  child: RaisedButton(
                    onPressed: () {
                      // Navigator.pop(context);
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (_) {
                      //       return ChangeNotifierProvider<UserViewModel>(
                      //         create: (context) => UserViewModel(),
                      //         child: homePage(),
                      //       );
                      //     }));
                    },
                    child: Text('MANGO 시작하기'),
                  ),
                )
                    : FlatButton(
                    onPressed: () {
                      // Navigator.pop(context);
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (_) {
                      //       return ChangeNotifierProvider<UserViewModel>(
                      //         create: (context) => UserViewModel(),
                      //         child: homePage(),
                      //       );
                      //     }));
                    },
                    child: Text('Skip'))
              ],
            ),
          ),
        );
      },
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
