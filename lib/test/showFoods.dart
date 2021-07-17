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
  var foods = ShowFoods.init(foodList: [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ], isFolds: [
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true
  ]).obs;
  //
  // changeView({required int view}) {
  //   viewType = view;
  //   update();
  // }

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

  loadFoodsWithCategory(
      {required String rID, required int idx, required String category}) async {
    await FirebaseFirestore.instance
        .collection('myFood')
        .where('rId', isEqualTo: rID)
        .where('category', isEqualTo: category)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        foods.update((val) {
          val?.showRefFoods[idx]
              .add(TemporaryFood.fromSnapshot(element.data()));
        });
      });
      print(foods.value.showRefFoods[idx].length);
    });
  }
}
