import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/view/widget/appBar.dart';
import 'package:mangodevelopment/view/widget/refrigerator/foodSections.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

class RefrigeratorPage extends StatefulWidget {
  String title;
  RefrigeratorPage({Key? key, required String title}) : title = title;

  @override
  _RefrigeratorPageState createState() => _RefrigeratorPageState();
}

class _RefrigeratorPageState extends State<RefrigeratorPage> {
  int currentTab = 0;

  late UserViewModel user;
  RefrigeratorViewModel refrigerator = Get.put(new RefrigeratorViewModel());

  //TODO: IS - Should add for view with category, shelfLife
  List<String> onceTitle = ['냉장', '냉동', '실온'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = Get.find<UserViewModel>();
    refrigerator
        .loadRefID(rID: user.user.value.refrigeratorID)
        .then((value) async {
      await refrigerator.loadFoods(rID: refrigerator.ref.value.rID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MangoAppBar(
        isLeading: false,
        title: widget.title,
      ),
      body: refrigeratorView(viewType: currentTab),
    );
  }

  Widget refrigeratorView({required int viewType}) {
    switch (viewType) {
      case 1:
        return viewWithShelfLife();
      case 2:
        return viewWithCategories();
      default:
        return viewWithOnce();
    }
  }

  Widget viewWithOnce() {
    return Column(children: [
      Obx(() {
        return FoodsSection(
            foods: refrigerator.ref.value.refrigerationFoods,
            title: onceTitle[0]);
      }),
      Obx(() {
        return FoodsSection(
            foods: refrigerator.ref.value.frozenFoods, title: onceTitle[1]);
      }),
      Obx(() {
        return FoodsSection(
            foods: refrigerator.ref.value.roomTempFoods, title: onceTitle[2]);
      }),
    ]);
  }

  Widget viewWithShelfLife() {
    return Column(children: [
      Obx(() {
        return FoodsSection(
            foods: refrigerator.ref.value.refrigerationFoods,
            title: onceTitle[0]);
      }),
      Obx(() {
        return FoodsSection(
            foods: refrigerator.ref.value.frozenFoods, title: onceTitle[1]);
      }),
      Obx(() {
        return FoodsSection(
            foods: refrigerator.ref.value.roomTempFoods, title: onceTitle[2]);
      }),
    ]);
  }

  Widget viewWithCategories() {
    return Column(children: [
      Obx(() {
        return FoodsSection(
            foods: refrigerator.ref.value.refrigerationFoods,
            title: onceTitle[0]);
      }),
      Obx(() {
        return FoodsSection(
            foods: refrigerator.ref.value.frozenFoods, title: onceTitle[1]);
      }),
      Obx(() {
        return FoodsSection(
            foods: refrigerator.ref.value.roomTempFoods, title: onceTitle[2]);
      }),
    ]);
  }
}
