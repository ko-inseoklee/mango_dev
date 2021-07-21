import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/viewModel/categoryController.dart';
import 'showFood.dart';

class ShowFoodsController extends GetxController {
  var foods = ShowFoods.init(
      isModify: false,
      currentTab: 0,
      foodsLength: 0,
      allFold: true,
      canModifyFoods: [],
      foodList: [
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
      ],
      isFolds: [
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

  changeViewMode({required int viewMode}) {
    foods.update((val) {
      val!.currentTab = viewMode;
    });
  }

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

  changeIsModify() {
    foods.update((val) {
      val!.isModify = !val.isModify;
    });
  }

  clearCanModify() {
    foods.update((val) {
      for (TemporaryFood food in val!.canModifyFoods) {
        food.isModify = false;
      }
      val.canModifyFoods.clear();
    });
  }

  addCanModify({required TemporaryFood food}) {
    foods.update((val) {
      if (!val!.canModifyFoods.contains(food)) {
        val.canModifyFoods.add(food);
      }
    });
  }

  changeCanModify({required String fID, required int idx}) {
    foods.update((val) {
      var temp =
          val!.showRefFoods[idx].firstWhere((element) => element.fId == fID);

      if (!val.canModifyFoods.contains(temp)) {
        val.showRefFoods[idx]
            .firstWhere((element) => element.fId == fID)
            .isModify = true;
        val.canModifyFoods.add(temp);
      } else {
        val.showRefFoods[idx]
            .firstWhere((element) => element.fId == fID)
            .isModify = false;
        val.canModifyFoods.remove(temp);
      }

      print('after length : ${val.canModifyFoods.length}');
    });
  }

  removeCanModify({required String fID}) {
    foods.update((val) {
      if (val!.canModifyFoods.contains(fID)) {
        val.canModifyFoods.remove(fID);
      }
    });
  }

  foldAll({required int storeType, required bool isFold}) {
    int from = 0;
    int to = 0;
    switch (storeType) {
      case 1:
        from = 0;
        to = 2;
        break;
      case 2:
        from = 3;
        to = 14;
        break;
      default:
        from = 15;
        to = 20;
    }
    foods.update((val) {
      for (int i = from; i <= to; i++) {
        val!.showInOnceIsFolds[i] = isFold ? false : true;
      }
      val!.allFold = !val.allFold;
    });
  }

  getFoodsLength({required String rID}) async {
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
    for (int i = 0; i <= 20; i++) {
      this.clearFoods(idx: i);
    }
    await loadFoodsWithShelfOver(rID: rID);
    await loadFoodsWithShelfDDay(rID: rID);
    await loadFoodsWithRefRegister(rID: rID);
    await loadFoodsWithFroRegister(rID: rID);
    await loadFoodsWithRTRegister(rID: rID);
    await loadFoodsNormal(rID: rID);
    for (int i = 0; i < 3; i++) {
      await loadFoodsWithStoreType(rID: rID, storeType: i);
    }
    for (int i = 3; i < 15; i++) {
      await loadFoodsWithCategory(
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
        TemporaryFood temp = TemporaryFood.fromSnapshot(element.data());

        foods.update((val) {
          if (!val!.showRefFoods[20].contains(temp))
            val.showRefFoods[20].add(temp);
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
        TemporaryFood temp = TemporaryFood.fromSnapshot(element.data());

        foods.update((val) {
          if (!val!.showRefFoods[15].contains(temp))
            val.showRefFoods[15].add(temp);
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
        TemporaryFood temp = TemporaryFood.fromSnapshot(element.data());

        foods.update((val) {
          if (!val!.showRefFoods[16].contains(temp))
            val.showRefFoods[16].add(temp);
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
        TemporaryFood temp = TemporaryFood.fromSnapshot(element.data());
        foods.update((val) {
          if (!val!.showRefFoods[17].contains(temp))
            val.showRefFoods[17].add(temp);
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
        TemporaryFood temp = TemporaryFood.fromSnapshot(element.data());
        foods.update((val) {
          if (!val!.showRefFoods[18].contains(temp))
            val.showRefFoods[18].add(temp);
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
        TemporaryFood temp = TemporaryFood.fromSnapshot(element.data());
        foods.update((val) {
          if (!val!.showRefFoods[19].contains(temp))
            val.showRefFoods[19].add(temp);
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
        TemporaryFood temp = TemporaryFood.fromSnapshot(element.data());
        foods.update((val) {
          if (!val!.showRefFoods[19].contains(temp))
            val.showRefFoods[19].add(temp);
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
        TemporaryFood temp = TemporaryFood.fromSnapshot(element.data());
        foods.update((val) {
          if (!val!.showRefFoods[storeType].contains(temp))
            val.showRefFoods[storeType].add(temp);
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
        TemporaryFood temp = TemporaryFood.fromSnapshot(element.data());

        foods.update((val) {
          if (!val!.showRefFoods[idx].contains(temp))
            val.showRefFoods[idx].add(temp);
        });
      });
    });
  }

  deleteFood({required String rID, required List<TemporaryFood> foods}) async {
    for (TemporaryFood food in foods) {
      await FirebaseFirestore.instance
          .collection('myFood')
          .doc(food.fId)
          .delete();
    }
    await loadAllFoods(rID: rID);
  }
}
