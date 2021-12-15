import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/color.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/view/widget/appBar.dart';
import 'package:mangodevelopment/view/widget/dialog/dialog.dart';
import 'package:mangodevelopment/view/widget/refrigerator/foodSections.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

//remerge

class RefrigeratorPage extends StatefulWidget {
  String title;

  RefrigeratorPage({Key? key, required String title}) : title = title;

  @override
  _RefrigeratorPageState createState() => _RefrigeratorPageState();
}

class _RefrigeratorPageState extends State<RefrigeratorPage> {
  int currentTab = 0;

  late UserViewModel user;
  late RefrigeratorViewModel refrigerator;

  //TODO: IS - Should add for view with category, shelfLife
  List<String> onceTitle = ['냉장', '냉동', '실온'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = Get.find<UserViewModel>();
    refrigerator = Get.find<RefrigeratorViewModel>();
    refrigerator
        .loadRefID(rID: user.user.value.refrigeratorID)
        .then((value) async {
      await refrigerator.loadFoods(rID: refrigerator.ref.value.rID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: MangoWhite,
        appBar: MangoAppBar(
          isLeading: false,
          title: widget.title,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                child: Container(
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('알림 확인'),
                  ),
                ),
                onTap: () {
                  refrigerator.ref.value.refrigerationFoods.forEach((element) {
                    int date =
                        element.shelfLife.difference(DateTime.now()).inDays;
                    if (date < user.user.value.refrigerationAlarm) {
                      if (date < 0)
                        Get.dialog(mangoDialog(
                          hasOK: true,
                          dialogTitle: element.name,
                          onTapOK: () async {
                            Get.back();
                          },
                          contentText: (element.shelfLife
                                          .difference(DateTime.now())
                                          .inDays *
                                      -1)
                                  .toString() +
                              '일 지났습니다.',
                        ));
                      else
                        Get.dialog(mangoDialog(
                          hasOK: true,
                          dialogTitle: element.name,
                          onTapOK: () async {
                            Get.back();
                          },
                          contentText: element.shelfLife
                                  .difference(DateTime.now())
                                  .inDays
                                  .toString() +
                              '일 남았습니다',
                        ));
                    }
                  });
                  // Get.snackbar(
                  //     '유통기한 알림',
                  //     '2');
                },
              ),
              Container(height: ScreenUtil().setHeight(43), child: tabView()),
              // refrigerator.ref.value.frozenFoods.first.shelfLife
              //             .difference(DateTime.now())
              //             .inDays <
              //         0
              //     ? SizedBox(
              //         height: 100,
              //         child: Text('1'),
              //       )
              //     :
              // SizedBox(
              //   height: 100,
              //   child: Text(refrigerator.ref.value.refrigerationFoods.first.shelfLife
              //       .difference(DateTime.now())
              //       .inDays
              //       .toString()),
              // ),
              Container(
                height: ScreenUtil().setHeight(620),
                child: TabBarView(children: [
                  viewWithOnce(viewType: 0),
                  viewWithOnce(viewType: 1),
                  viewWithOnce(viewType: 2)
                ]),
              ),
              // viewWithOnce(viewType: currentTab),
            ],
          ),
        ),
      ),
    );
  }

  // Widget refrigeratorView({required int viewType}) {
  //   switch (viewType) {
  //     case 1:
  //       return viewWithShelfLife();
  //     case 2:
  //       return viewWithCategories();
  //     default:
  //       return viewWithOnce();
  //   }
  // }

  Widget viewWithOnce({required int viewType}) {
    return viewType == 1
        ? Obx(() {
            // refrigerator.ref.value.frozenFoods.forEach((element) {
            //   print("!!");
            // if element -> shelflife <2
            //   Get.snackbar(
            //       '유통기한 알림',
            //       element.shelfLife
            //           .difference(DateTime.now())
            //           .inDays
            //           .toString());
            // });
            return FoodsSection(
              foods: refrigerator.ref.value.frozenFoods,
              title: onceTitle[1],
              isPost: false,
            );
          })
        : viewType == 2
            ? Obx(() {
                return FoodsSection(
                  foods: refrigerator.ref.value.roomTempFoods,
                  title: onceTitle[2],
                  isPost: false,
                );
              })
            : Obx(() {
                return FoodsSection(
                  foods: refrigerator.ref.value.refrigerationFoods,
                  title: onceTitle[0],
                  isPost: false,
                );
              });
  }

  Widget viewWithShelfLife() {
    return Column(children: [
      Obx(() {
        return FoodsSection(
            foods: refrigerator.ref.value.refrigerationFoods,
            title: onceTitle[0],
            isPost: false);
      }),
      Obx(() {
        return FoodsSection(
            foods: refrigerator.ref.value.frozenFoods,
            title: onceTitle[1],
            isPost: false);
      }),
      Obx(() {
        return FoodsSection(
            foods: refrigerator.ref.value.roomTempFoods,
            title: onceTitle[2],
            isPost: false);
      }),
    ]);
  }

  Widget viewWithCategories() {
    return Column(children: [
      Obx(() {
        return FoodsSection(
            foods: refrigerator.ref.value.refrigerationFoods,
            title: onceTitle[0],
            isPost: false);
      }),
      Obx(() {
        return FoodsSection(
            foods: refrigerator.ref.value.frozenFoods,
            title: onceTitle[1],
            isPost: false);
      }),
      Obx(() {
        return FoodsSection(
            foods: refrigerator.ref.value.roomTempFoods,
            title: onceTitle[2],
            isPost: false);
      }),
    ]);
  }

  Widget tabView() {
    return TabBar(
      unselectedLabelColor: MangoDisabledColorDark,
      labelColor: Orange700,
      indicatorColor: Orange400,
      tabs: [
        Tab(
          text: '냉장',
          // child: Text('냉장'),
        ),
        Tab(
          text: '냉동',
          // child: Text('냉동'),
        ),
        Tab(
          text: '실온',
          // child: Text('실온'),
        )
      ],
    );
  }
}
