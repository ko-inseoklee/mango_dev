import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RefrigeratorView {
  int viewType = 0;
  bool refIsFold = true;
  bool froIsFold = true;
}

class RefrigeratorViewController extends GetxController {
  var foodSection = new RefrigeratorView().obs;

  changeViewType({required int type}) {
    foodSection.update((val) {
      val!.viewType = type;
    });
  }

  changeRefIsFold({required bool isFold}) {
    foodSection.update((val) {
      val!.refIsFold = isFold;
    });
  }

  changeFroIsFold({required bool isFold}) {
    foodSection.update((val) {
      val!.froIsFold = isFold;
    });
  }
}
