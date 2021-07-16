import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/refrigerator/addFoodDirect.dart';
import 'package:mangodevelopment/view/widget/foodSections.dart';

class FoodSectionsController extends GetxController {
  RxBool isSelected = false.obs;

  var foodSections = new FoodSections(
      title: '',
      isFold: true,
      isSelected: true,
      onPressed: () {},
      onSelectParam: (value) {},
      foods: []).obs;

  change({
    required String title,
    required bool isFold,
    required bool isSelected,
    required VoidCallback onPressed,
    required Function(String) onSelectParam,
    required List<TemporaryFood> foods,
  }) {
    foodSections.update((value) {
      value?.title = title;
      value?.isFold = isFold;
      value?.isSelected = isSelected;
      value?.onPressed = onPressed;
      value?.onSelectParam = onSelectParam;
      value?.foods = foods;
    });
  }
}
