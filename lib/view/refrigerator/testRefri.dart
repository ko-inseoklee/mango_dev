import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/app.dart';
import 'package:mangodevelopment/color.dart';
import 'package:mangodevelopment/test/foodSections.dart';

class SubRefrigeratorPage extends StatelessWidget {
  final String title;
  SubRefrigeratorPage({Key? key, required this.title}) : super(key: key);

  var _refViewController =
      Get.put<RefrigeratorViewController>(RefrigeratorViewController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            centerTitle: true,
          ),
          body: GetX<RefrigeratorViewController>(
            builder: (_) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: deviceWidth / 3,
                        height: 40,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: _.foodSection.value.viewType == 0
                                    ? BorderSide(color: Orange400)
                                    : BorderSide.none)),
                        child: TextButton(
                          child: Text(
                            '유통기한별 보기',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                    color: _.foodSection.value.viewType == 0
                                        ? Orange400
                                        : MangoDisabledColor),
                          ),
                          onPressed: () {
                            _.changeViewType(type: 0);
                          },
                        ),
                      ),
                      Container(
                        width: deviceWidth / 3,
                        height: 40,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: _.foodSection.value.viewType == 1
                                    ? BorderSide(color: Orange400)
                                    : BorderSide.none)),
                        child: TextButton(
                          child: Text(
                            '한눈에 보기',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                    color: _.foodSection.value.viewType == 1
                                        ? Orange400
                                        : MangoDisabledColor),
                          ),
                          onPressed: () {
                            _.changeViewType(type: 1);
                          },
                        ),
                      ),
                      Container(
                        width: deviceWidth / 3,
                        height: 40,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: _.foodSection.value.viewType == 2
                                    ? BorderSide(color: Orange400)
                                    : BorderSide.none)),
                        child: TextButton(
                          child: Text(
                            '카테고리별 보기',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    color: _.foodSection.value.viewType == 2
                                        ? Orange400
                                        : MangoDisabledColor),
                          ),
                          onPressed: () {
                            _.changeViewType(type: 2);
                          },
                        ),
                      ),
                    ],
                  ),
                  showInOnce(_.foodSection.value.viewType)
                  // _.foodSection.value.viewType == 0
                  //     ? showInOnce(_.foodSection.value.viewType)
                  //     : _.foodSection.value.viewType == 1
                  //         ? showInOnce(_.foodSection.value.viewType)
                  //         : Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Text('카테고리별 보기'),
                  //           )
                ],
              );
            },
          )),
    );
  }

  Widget showInOnce(int idx) {
    return Padding(
        padding: const EdgeInsets.all(8.0), child: Text('유통기한 보기 $idx'));
  }
}
