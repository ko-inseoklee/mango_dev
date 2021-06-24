import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/color.dart';

class MangoBottomNavigationBar extends StatelessWidget {
  final MangoBNBController controller;

  const MangoBottomNavigationBar({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MangoBNBController>(
        init: controller,
        builder: (_) {
          return BottomNavigationBar(
            unselectedItemColor: MangoDisabledColor,
            currentIndex: _.tabIndex.value,
            onTap: _.changeTabIndex,
            selectedItemColor: Orange400,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: [
              _MangoBottomItem(icon: Icons.kitchen_outlined, label: '냉장고'),
              _MangoBottomItem(icon: Icons.shopping_cart_outlined, label: '마켓'),
              _MangoBottomItem(icon: Icons.local_mall_outlined, label: '거래광장'),
              _MangoBottomItem(
                  icon: Icons.fact_check_outlined, label: '냉장고 분석'),
              _MangoBottomItem(
                  icon: Icons.account_box_outlined, label: '마이 페이지')
            ],
          );
        });
  }

  _MangoBottomItem({required IconData icon, required String label}) {
    return BottomNavigationBarItem(icon: Icon(icon), label: label);
  }
}

class MangoBNBController extends GetxController {
  var tabIndex = 0.obs;

  void changeTabIndex(int index) {
    tabIndex = index.obs;
    print(this.tabIndex.value);
    update();
  }
}
