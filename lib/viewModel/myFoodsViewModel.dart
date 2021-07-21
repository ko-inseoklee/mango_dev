import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/model/myFood.dart';
import 'package:mangodevelopment/view/refrigerator/addFoodDirect.dart';
import 'package:mangodevelopment/model/food.dart';

class MyFoodsViewModel extends GetxController {
  List<TemporaryFood>? foods;
  List<MyFood>? _myFoods;

  MyFoodsViewModel() {
    foods = [];
    _myFoods = [];
  }

  MyFoodsViewModel.init() {
    foods = [];
    _myFoods = [];
  }

  Future<List<TemporaryFood>> loadFoods(String refID) async {
    var data = await FirebaseFirestore.instance
        .collection('myFood')
        .where('rId', isEqualTo: refID)
        .get();

    data.docs.forEach((element) {
      this.foods!.add(TemporaryFood.fromSnapshot(element.data()));
    });

    return this.foods!;
  }

  Future<List<TemporaryFood>> loadFoodsByStoreType(
      String refID, int storeType) async {
    List<TemporaryFood> result = [];

    var data = await FirebaseFirestore.instance
        .collection('myFood')
        .where('rId', isEqualTo: refID)
        .where('storeType', isEqualTo: storeType)
        .get();

    data.docs.forEach((element) {
      result.add(TemporaryFood.fromSnapshot(element.data()));
    });

    return result;
  }

  Future<List<TemporaryFood>> loadFoodsByCategory(
      String refID, String category) async {
    List<TemporaryFood> result = [];

    var data = await FirebaseFirestore.instance
        .collection('myFood')
        .where('rId', isEqualTo: refID)
        .where('category', isEqualTo: category)
        .get();

    data.docs.forEach((element) {
      result.add(TemporaryFood.fromSnapshot(element.data()));
    });

    return result;
  }

  Future<void> addFoods(String refID, List<TemporaryFood> foods) async {
    for (TemporaryFood food in foods) {
      int i = 0;

      await FirebaseFirestore.instance.collection('myFood').doc(food.fId).set({
        'fId': food.fId,
        'rId': food.rId,
        'name': food.name,
        'category': food.category,
        'number': food.number,
        'storeType': food.method,
        'displayType': food.displayType,
        'shelfLife': food.shelfLife,
        'registrationDay': food.registrationDay,
        'registerNormal': food.registerNormal,
        'registerRefAbnormal': food.registerRefAbnormal,
        'registerFroAbnormal': food.registerFroAbnormal,
        'registerRTAbnormal': food.registerRTAbnormal,
        'shelfNormal': food.shelfNormal,
        'shelfDDay': food.shelfDDay,
        'shelfOver': food.shelfOver,
        'isModify': food.isModify
      });
    }
  }

  Future<void> updateFood(String refID, List<TemporaryFood> foods) async {
    for (TemporaryFood food in foods) {
      int i = 0;

      await FirebaseFirestore.instance
          .collection('myFood')
          .doc(food.fId)
          .update({
        'fId': food.fId,
        'rId': food.rId,
        'name': food.name,
        'category': food.category,
        'number': food.number,
        'storeType': food.method,
        'displayType': food.displayType,
        'shelfLife': food.shelfLife,
        'registrationDay': food.registrationDay,
        'registerNormal': food.registerNormal,
        'registerRefAbnormal': food.registerRefAbnormal,
        'registerFroAbnormal': food.registerFroAbnormal,
        'registerRTAbnormal': food.registerRTAbnormal,
        'shelfNormal': food.shelfNormal,
        'shelfDDay': food.shelfDDay,
        'shelfOver': food.shelfOver,
        'isModify': food.isModify
      });
    }
  }

  List<TemporaryFood> sortByCategory(
      List<TemporaryFood> foods, String category) {
    List<TemporaryFood> _tempFood = [];

    foods.forEach((element) {
      if (element.category == category) {
        _tempFood.add(element);
      }
    });

    return _tempFood;
  }
}
