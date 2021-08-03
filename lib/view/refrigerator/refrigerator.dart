import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/widget/foodSections.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';

import 'package:mangodevelopment/viewModel/userViewModel.dart';

List<String> canModifyFoods = [];

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = Get.find<UserViewModel>();
    refrigerator
        .loadRefID(rID: user.user.value.refrigeratorID)
        .then((value) async {
      print(refrigerator.ref.value.rID);
      await refrigerator.loadFoods(rID: refrigerator.ref.value.rID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: refrigeratorView(viewType: 0),
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
    return Column(
      children: [
        Obx(() {
          return FoodsSection(
              foods: refrigerator.ref.value.refrigerationFoods, title: '냉장');
        }),
        Obx(() {
          return FoodsSection(
              foods: refrigerator.ref.value.frozenFoods, title: '냉동');
        }),
        Obx(() {
          return FoodsSection(
              foods: refrigerator.ref.value.roomTempFoods, title: '실온');
        })
      ],
    );
  }

  Widget viewWithShelfLife() {
    return Column(
      children: [
        Obx(() {
          return FoodsSection(
              foods: refrigerator.ref.value.refrigerationFoods, title: '냉장');
        }),
        Obx(() {
          return FoodsSection(
              foods: refrigerator.ref.value.frozenFoods, title: '냉동');
        }),
        Obx(() {
          return FoodsSection(
              foods: refrigerator.ref.value.roomTempFoods, title: '실온');
        })
      ],
    );
  }

  Widget viewWithCategories() {
    return Column(
      children: [
        Obx(() {
          return FoodsSection(
              foods: refrigerator.ref.value.refrigerationFoods, title: '냉장');
        }),
        Obx(() {
          return FoodsSection(
              foods: refrigerator.ref.value.frozenFoods, title: '냉동');
        }),
        Obx(() {
          return FoodsSection(
              foods: refrigerator.ref.value.roomTempFoods, title: '실온');
        })
      ],
    );
  }
}
