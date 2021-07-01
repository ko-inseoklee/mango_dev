import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/color.dart';
import 'package:mangodevelopment/view/refrigerator/test.dart';

import '../widget/appBar.dart';

class RefrigeratorPage extends StatefulWidget {
  final String title;

  const RefrigeratorPage({Key? key, required this.title}) : super(key: key);

  @override
  _RefrigeratorPageState createState() => _RefrigeratorPageState();
}

class _RefrigeratorPageState extends State<RefrigeratorPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  int tabIdx = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController =
        new TabController(length: 3, vsync: this, initialIndex: tabIdx);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: MangoAppBar(
          isLeading: false,
          title: '나의 냉장고',
        ),
        backgroundColor: MangoWhite,
        body: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 40,
                  child: TabBar(
                      controller: _tabController,
                      indicatorColor: Orange400,
                      onTap: (value) {
                        setState(() {
                          tabIdx = value;
                        });
                      },
                      tabs: showTab())),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text('냉장고가 비었습니다.'),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> showTab() {
    return <Widget>[
      Text(
        '한눈에 보기',
        style: Theme.of(context)
            .textTheme
            .subtitle2!
            .copyWith(color: tabIdx == 0 ? Orange400 : MangoDisabledColor),
      ),
      Text(
        '카테고리별 보기',
        style: Theme.of(context)
            .textTheme
            .subtitle2!
            .copyWith(color: tabIdx == 1 ? Orange400 : MangoDisabledColor),
      ),
      Text('유통기한별 보기',
          style: Theme.of(context)
              .textTheme
              .subtitle2!
              .copyWith(color: tabIdx == 2 ? Orange400 : MangoDisabledColor)),
    ];
  }
}
