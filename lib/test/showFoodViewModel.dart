import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/viewModel/categoryController.dart';
import 'showFood.dart';

class ShowFoodsController extends GetxController {
  var foods = ShowFoods.init(foodsLength: 0, foodList: [
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
    true,
    true,
    true,
    true,
    true,
    true,
    true
  ]).obs;

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

  getFoodsLength({required String rID}) async {
    print('get food == $rID');
    await FirebaseFirestore.instance
        .collection('myFood')
        .where('rId', isEqualTo: rID)
        .get()
        .then((value) {
      foods.update((val) {
        val?.foodsLength = value.docs.length;
      });
    });
  }

  loadAllFoods({required String rID}) async {
    loadFoodsWithShelfOver(rID: rID);
    loadFoodsWithShelfDDay(rID: rID);
    loadFoodsWithRefRegister(rID: rID);
    loadFoodsWithFroRegister(rID: rID);
    loadFoodsWithRTRegister(rID: rID);
    loadFoodsNormal(rID: rID);
    for (int i = 0; i < 3; i++) {
      loadFoodsWithStoreType(rID: rID, storeType: i);
    }
    for (int i = 3; i < 15; i++) {
      loadFoodsWithCategory(
        rID: rID,
        idx: i,
        category: categories[i - 3],
      );
    }
  }

  loadFoodsWithShelfOver({required String rID}) async {
    await FirebaseFirestore.instance
        .collection('myFood')
        .where('rId', isEqualTo: rID)
        .where('shelfOver', isEqualTo: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        foods.update((val) {
          val?.showRefFoods[20].add(TemporaryFood.fromSnapshot(element.data()));
        });
      });
      this
          .foods
          .value
          .showRefFoods[20]
          .sort((a, b) => a.shelfLife.compareTo(b.shelfLife));
    });
  }

  loadFoodsWithShelfDDay({required String rID}) async {
    await FirebaseFirestore.instance
        .collection('myFood')
        .where('rId', isEqualTo: rID)
        .where('shelfDDay', isEqualTo: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        foods.update((val) {
          val?.showRefFoods[15].add(TemporaryFood.fromSnapshot(element.data()));
        });
      });
      this
          .foods
          .value
          .showRefFoods[15]
          .sort((a, b) => a.shelfLife.compareTo(b.shelfLife));
    });
  }

  loadFoodsWithRefRegister({
    required String rID,
  }) async {
    await FirebaseFirestore.instance
        .collection('myFood')
        .where('rId', isEqualTo: rID)
        .where('registerRefAbnormal', isEqualTo: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        foods.update((val) {
          val?.showRefFoods[16].add(TemporaryFood.fromSnapshot(element.data()));
        });
      });
      this
          .foods
          .value
          .showRefFoods[16]
          .sort((a, b) => a.registrationDay.compareTo(b.registrationDay));
    });
  }

  loadFoodsWithFroRegister({
    required String rID,
  }) async {
    await FirebaseFirestore.instance
        .collection('myFood')
        .where('rId', isEqualTo: rID)
        .where('registerFroAbnormal', isEqualTo: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        foods.update((val) {
          val?.showRefFoods[17].add(TemporaryFood.fromSnapshot(element.data()));
        });
      });
      this
          .foods
          .value
          .showRefFoods[17]
          .sort((a, b) => a.registrationDay.compareTo(b.registrationDay));
    });
  }

  loadFoodsWithRTRegister({
    required String rID,
  }) async {
    await FirebaseFirestore.instance
        .collection('myFood')
        .where('rId', isEqualTo: rID)
        .where('registerRTAbnormal', isEqualTo: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        foods.update((val) {
          val?.showRefFoods[18].add(TemporaryFood.fromSnapshot(element.data()));
        });
      });
      this
          .foods
          .value
          .showRefFoods[18]
          .sort((a, b) => a.registrationDay.compareTo(b.registrationDay));
    });
  }

  loadFoodsNormal({required String rID}) async {
    await FirebaseFirestore.instance
        .collection('myFood')
        .where('rId', isEqualTo: rID)
        .where('registerNormal', isEqualTo: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        foods.update((val) {
          val?.showRefFoods[19].add(TemporaryFood.fromSnapshot(element.data()));
        });
      });
    });

    await FirebaseFirestore.instance
        .collection('myFood')
        .where('rId', isEqualTo: rID)
        .where('shelfNormal', isEqualTo: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        foods.update((val) {
          val?.showRefFoods[19].add(TemporaryFood.fromSnapshot(element.data()));
        });
      });
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
    });
  }
}
