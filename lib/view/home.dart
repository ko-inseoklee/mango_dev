import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/analyze/nutrition.dart';
import 'package:mangodevelopment/view/market/market.dart';
import 'package:mangodevelopment/view/myAccount/myPage.dart';
import 'package:mangodevelopment/view/refrigerator/addFoodSheet.dart';
import 'package:mangodevelopment/view/refrigerator/refrigerator.dart';
import 'package:mangodevelopment/view/trade/trade.dart';
import 'package:mangodevelopment/viewModel/tempUserViewModel.dart';

import '../color.dart';
import '../viewModel/refrigeratorViewModel.dart';
import './widget/bottomNavigationBar/bottomNavigationBar.dart';

class HomePage extends StatefulWidget {
  final title;
  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  MangoBNBController _controller = MangoBNBController();
  late TempUserViewModel currentUser;

  @override
  Widget build(BuildContext context) {
    currentUser = Get.put(TempUserViewModel());

    currentUser.FindTempUserSnapshot('123');

    return GetBuilder<MangoBNBController>(
      init: _controller,
      builder: (_) {
        return Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: _controller.tabIndex.value,
              children: [
                RefrigeratorPage(title: '나의 냉장고'),
                MarketPage(title: '마켓 페이지'),
                TradePage(title: '거래 광장 페이지'),
                NutritionPage(title: '영양 정보 페이지'),
                MyPage(title: '마이 페이지'),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Orange400,
            onPressed: () {
              // showDialog(
              //     context: context,
              //     builder: (_) {
              //       return AddFoodSheet();
              //     });
              Get.dialog(AddFoodSheet());
            },
            child: Icon(Icons.add),
          ),
          bottomNavigationBar: MangoBottomNavigationBar(
            controller: _controller,
          ),
        );
      },
    );
  }
}
