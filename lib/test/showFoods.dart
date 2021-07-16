import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/refrigerator/addFoodDirect.dart';

class ShowFoods {
  List<List<TemporaryFood>> showRefFoods = [];
  List<bool> showInOnceIsFolds = [];

  ShowFoods.init(
      {required List<List<TemporaryFood>> foodList,
      required List<bool> isFolds})
      : showRefFoods = foodList,
        showInOnceIsFolds = isFolds;
}

class ShowFoodsController extends GetxController {
  var foods =
      ShowFoods.init(foodList: [[], [], []], isFolds: [true, true, true]).obs;

  changeBool({required bool isFold, required int idx}) {
    foods.update((val) {
      val!.showInOnceIsFolds[idx] = isFold;
    });
  }

  addFoods({required List<TemporaryFood> food, required int idx}) {
    foods.update((val) {
      val!.showRefFoods[idx] = food;
    });
  }

  clearFoods({required int idx}) {
    foods.update((val) {
      val!.showRefFoods[idx].clear();
    });
  }

  loadFoodsWithStoreType({required String rID, required int storeType}) async {
    await FirebaseFirestore.instance
        .collection('myFood')
        .where('rId', isEqualTo: rID)
        .where('storeType', isEqualTo: storeType)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        foods.update((val) {
          val?.showRefFoods[storeType]
              .add(TemporaryFood.fromSnapshot(element.data()));
        });
      });
      print(foods.value.showRefFoods[storeType].length);
    });
  }
}
