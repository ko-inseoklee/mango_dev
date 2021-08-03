import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/refrigerator/addFoodDirect.dart';
import 'package:mangodevelopment/model/food.dart';

class MyFoodsViewModel extends GetxController {
  List<Food>? foods;

  MyFoodsViewModel() {
    foods = [];
  }

  MyFoodsViewModel.init() {
    foods = [];
  }

  Future<List<Food>> loadFoods(String refID) async {
    var data = await FirebaseFirestore.instance
        .collection('myFood')
        .where('rId', isEqualTo: refID)
        .get();

    data.docs.forEach((element) {
      this.foods!.add(Food.fromSnapshot(element.data()));
    });

    return this.foods!;
  }

  Future<List<Food>> loadFoodsByStoreType(String refID, int storeType) async {
    List<Food> result = [];

    var data = await FirebaseFirestore.instance
        .collection('myFood')
        .where('rId', isEqualTo: refID)
        .where('storeType', isEqualTo: storeType)
        .get();

    data.docs.forEach((element) {
      result.add(Food.fromSnapshot(element.data()));
    });

    return result;
  }

  Future<List<Food>> loadFoodsByCategory(String refID, String category) async {
    List<Food> result = [];

    var data = await FirebaseFirestore.instance
        .collection('myFood')
        .where('rId', isEqualTo: refID)
        .where('category', isEqualTo: category)
        .get();

    data.docs.forEach((element) {
      result.add(Food.fromSnapshot(element.data()));
    });

    return result;
  }

  Future<void> addFoods(String refID, List<Food> foods) async {
    for (Food food in foods) {
      int i = 0;

      await FirebaseFirestore.instance.collection('myFood').doc(food.fId).set({
        'fId': food.fId,
        'rId': refID,
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

  Future<void> updateFood(String refID, List<Food> foods) async {
    for (Food food in foods) {
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

  void deleteRef({required String uid}) {
    var refID;
    FirebaseFirestore.instance
        .collection('refrigeraotr')
        .where('userID', isEqualTo: uid)
        .get()
        .then((value) => refID = value.docs.first.data()['refID']);
    FirebaseFirestore.instance.collection('re').doc(refID).delete();
  }

  List<Food> sortByCategory(List<Food> foods, String category) {
    List<Food> _tempFood = [];

    foods.forEach((element) {
      if (element.category == category) {
        _tempFood.add(element);
      }
    });

    return _tempFood;
  }
}
