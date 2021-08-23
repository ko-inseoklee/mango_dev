import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/color.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/view/widget/appBar.dart';
import 'package:mangodevelopment/view/widget/refrigerator/foodSections.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

class selectPostFoodPage extends StatefulWidget {
  String title;
  selectPostFoodPage({Key? key, required String title}) : title = title;

  @override
  _selectPostFoodPage createState() => _selectPostFoodPage();
}

class _selectPostFoodPage extends State<selectPostFoodPage> {
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
          isLeading: true,
          title: widget.title,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(height: ScreenUtil().setHeight(43), child: tabView()),
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

  Widget viewWithOnce({required int viewType}) {
    return viewType == 1
        ? Obx(() {
            return FoodsSection(
              foods: refrigerator.ref.value.frozenFoods,
              title: onceTitle[1],
              isPost: true,
            );
          })
        : viewType == 2
            ? Obx(() {
                return FoodsSection(
                  foods: refrigerator.ref.value.roomTempFoods,
                  title: onceTitle[2],
                  isPost: true,
                );
              })
            : Obx(() {
                return FoodsSection(
                  foods: refrigerator.ref.value.refrigerationFoods,
                  title: onceTitle[0],
                  isPost: true,
                );
              });
  }

  Widget viewWithShelfLife() {
    return Column(children: [
      Obx(() {
        return FoodsSection(
          foods: refrigerator.ref.value.refrigerationFoods,
          title: onceTitle[0],
          isPost: true,
        );
      }),
      Obx(() {
        return FoodsSection(
          foods: refrigerator.ref.value.frozenFoods,
          title: onceTitle[1],
          isPost: true,
        );
      }),
      Obx(() {
        return FoodsSection(
          foods: refrigerator.ref.value.roomTempFoods,
          title: onceTitle[2],
          isPost: true,
        );
      }),
    ]);
  }

  Widget viewWithCategories() {
    return Column(children: [
      Obx(() {
        return FoodsSection(
          foods: refrigerator.ref.value.refrigerationFoods,
          title: onceTitle[0],
          isPost: true,
        );
      }),
      Obx(() {
        return FoodsSection(
          foods: refrigerator.ref.value.frozenFoods,
          title: onceTitle[1],
          isPost: true,
        );
      }),
      Obx(() {
        return FoodsSection(
          foods: refrigerator.ref.value.roomTempFoods,
          title: onceTitle[2],
          isPost: true,
        );
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
