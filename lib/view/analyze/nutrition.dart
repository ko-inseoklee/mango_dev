import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/analyze/textAI.dart';

class NutritionPage extends StatefulWidget {
  final String title;

  const NutritionPage({Key? key, required this.title}) : super(key: key);

  @override
  _NutritionPageState createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  int index = 0;

  List<String> imgList = [
    'images/prototype/nutrition1.png',
    'images/prototype/nutrition2.png',
    'images/prototype/nutrition3.png',
  ];

  final prototypeDotSize = ScreenUtil().setSp(12);
  final prototypeDotPadding = ScreenUtil().setWidth(7.5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: ScreenUtil().setHeight(0.1),
            ),
            Expanded(
              child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: PageController(initialPage: 0),
                  onPageChanged: (int index) {
                    setState(() {
                      this.index = index;
                    });
                  },
                  itemCount: imgList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            imgList[index],
                            width: ScreenUtil().setWidth(320),
                            height: ScreenUtil().setHeight(467),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            Container(child: scrollProgress(index)),
            SizedBox(
              height: ScreenUtil().setHeight(30),
            )
          ],
        ),
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
      ],
    );
  }

  Widget activeIcon() {
    return Padding(
        padding:
            EdgeInsets.fromLTRB(prototypeDotPadding, 0, prototypeDotPadding, 0),
        child: Icon(
          Icons.fiber_manual_record,
          size: prototypeDotSize,
          color: Theme.of(context).accentColor,
        ));
  }

  Widget inactiveIcon() {
    return Padding(
      padding:
          EdgeInsets.fromLTRB(prototypeDotPadding, 0, prototypeDotPadding, 0),
      child: Icon(
        Icons.fiber_manual_record,
        size: prototypeDotSize,
        color: Theme.of(context).unselectedWidgetColor,
      ),
    );
  }
}
