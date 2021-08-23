import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/model/refrigerator.dart';
import 'package:mangodevelopment/view/widget/comingSoon.dart';

class RefrigeratorViewModel extends GetxController {
  var ref = new Refrigerator.init(
      rID: '', uID: '', refFoods: [], froFoods: [], rTFoods: []).obs;

  Future<void> createRefrigeratorID(String uid, String rid) async {
    await FirebaseFirestore.instance.collection('refrigerator').doc(rid).set({
      'refID': rid,
      'userID': uid,
    });
  }

  loadRefID({required String rID}) async {
    await FirebaseFirestore.instance
        .collection('refrigerator')
        .doc(rID)
        .get()
        .then((value) {
      if (value.exists) {
        Map<String, dynamic> data = value.data() as Map<String, dynamic>;
        ref.update((val) {
          val?.uID = data['userID'];
          val?.rID = data['refID'];
        });
      } else {
        print('Load Fail..');
      }
    });
  }

  Future<void> deleteRefrigerator({required String rID}) async {
    await FirebaseFirestore.instance
        .collection('myFood')
        .where('rId', isEqualTo: rID)
        .get()
        .then((value) async {
      List<Food> foods = [];
      value.docs.forEach((element) {
        foods.add(Food.fromSnapshot(element.data()));
      });
      this.deleteFoods(foods: foods);
      await FirebaseFirestore.instance
          .collection('refrigerator')
          .doc(rID)
          .delete()
          .then((value) => print('success to delete refrigerator'));
    });
  }

  loadFoods({required String rID}) async {
    await FirebaseFirestore.instance
        .collection('myFood')
        .where('rId', isEqualTo: rID)
        .get()
        .then((value) {
      if (value.size > 0) {
        List<Food> tempRef = [];
        List<Food> tempFro = [];
        List<Food> tempRT = [];

        value.docs.forEach((element) {
          Food temp = Food.fromSnapshot(element.data());

          ref.update((val) {
            if (temp.method == 2) {
              tempRT.add(temp);
            } else if (temp.method == 1) {
              tempFro.add(temp);
            } else {
              tempRef.add(temp);
            }
            val!.refrigerationFoods = tempRef;
            val.frozenFoods = tempFro;
            val.roomTempFoods = tempRT;
          });
        });
      } else {
        print('load Food - 사이즈가 0 입니다.');
      }
    });
  }

  Future<void> addFoods(List<Food> foods) async {
    for (Food food in foods) {
      await FirebaseFirestore.instance.collection('myFood').doc(food.fId).set({
        'fId': food.fId,
        'rId': this.ref.value.rID,
        'name': food.name,
        'category': food.category,
        'number': food.number,
        'storeType': food.method,
        'displayType': food.displayType,
        'shelfLife': food.shelfLife,
        'registrationDay': food.registrationDay,
        'alarmDay': food.alarmDay,
        'cardStatus': food.cardStatus
      }).then((value) {
        ref.update((val) {
          if (food.method == 1) {
            val!.frozenFoods.add(food);
          } else if (food.method == 2) {
            val!.roomTempFoods.add(food);
          } else {
            val!.refrigerationFoods.add(food);
          }
        });
      });
    }
  }

  Future<void> updateFood({required Food food}) async {
    await FirebaseFirestore.instance.collection('myFood').doc(food.fId).set({
      'fId': food.fId,
      'rId': this.ref.value.rID,
      'name': food.name,
      'category': food.category,
      'number': food.number,
      'storeType': food.method,
      'displayType': food.displayType,
      'shelfLife': food.shelfLife,
      'registrationDay': food.registrationDay,
      'alarmDay': food.alarmDay,
      'cardStatus': food.cardStatus
    }).then((value) {
      ref.update((val) {
        loadFoods(rID: val!.rID);
      });
    });
  }

  Future<void> deleteFood({required String fID}) async {
    await FirebaseFirestore.instance
        .collection('myFood')
        .doc(fID)
        .delete()
        .then((value) {
      ref.update((val) {
        loadFoods(rID: val!.rID);
      });
    });
  }

  Future<void> deleteFoods({required List<Food> foods}) async {
    foods.forEach((element) async {
      await FirebaseFirestore.instance
          .collection('myFood')
          .doc(element.fId)
          .delete();
    });
    ref.update((val) {
      loadFoods(rID: val!.rID);
    });
  }

  void updateShelf({required DateTime lastSignIn}) {
    print(DateTime.now().difference(lastSignIn).inMinutes);
    print(DateTime.now());
    print(DateTime.now().subtract(Duration(hours: 12)));
    print(DateTime.now()
        .difference(DateTime.now().subtract(Duration(hours: 12)))
        .inDays);
    print(DateFormat().format(DateTime.now()));
  }

  // IS - this is view lists for other viewMode on refrigerator page.
  showFoods({required int viewType}) {
    switch (viewType) {
      case 1:
        showFoodsWithShelfLife();
        break;
      case 2:
        showFoodsWithCategories();
        break;
      default:
        showFoodsWithStoreType();
    }
  }

  void showFoodsWithShelfLife() {}

  void showFoodsWithCategories() {}

  void showFoodsWithStoreType() {}
}
