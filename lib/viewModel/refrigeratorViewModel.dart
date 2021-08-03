import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/model/refrigerator.dart';
import 'package:mangodevelopment/view/widget/comingSoon.dart';

class RefrigeratorViewModel extends GetxController {
  var ref = new Refrigerator.init(rID: '', uID: '', foods: []).obs;

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
        .where('rID', isEqualTo: rID)
        .get()
        .then((value) {
      if (value.size > 0) {
        value.docs.forEach((element) {
          Food temp = Food.fromSnapshot(element.data());

          ref.update((val) {
            val!.foods.add(temp);
          });
        });
      } else {
        print('사이즈가 0 입니다.');
      }
    });
  }

  Future<void> createRefrigeratorID(String uid, String rid) async {
    await FirebaseFirestore.instance.collection('refrigerator').doc(rid).set({
      'refID': rid,
      'userID': uid,
    });
  }
}
