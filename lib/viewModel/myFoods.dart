import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/model/myFood.dart';
import 'package:mangodevelopment/view/refrigerator/addFoodD.dart';

class myFoods {
  List<TemporaryFood> foods = [];

  Future<void> loadFoods(String refID) async {
    List<TemporaryFood> foods = [];

    var data = await FirebaseFirestore.instance
        .collection('refrigerator')
        .doc(refID)
        .collection('foods');

    data
        .get()
        .then((value) => print(value.docs.map((e) => print('id == ${e.id}'))));
  }

  Future<void> addFoods(String refID, List<TemporaryFood> foods) async {
    for (TemporaryFood food in foods) {
      await FirebaseFirestore.instance
          .collection('refrigerator')
          .doc(refID)
          .collection('foods')
          .doc(food.name)
          .set({
        'name': food.name,
        'category': food.category,
        'number': food.number,
        'storeType': food.method,
        'shelfLife': food.shelfLife,
        'registrationDay': food.registrationDay,
      });
    }
  }
}
