import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            if (temp.method == 0) {
              tempRef.add(temp);
            } else if (temp.method == 1) {
              tempFro.add(temp);
            } else {
              tempRT.add(temp);
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
