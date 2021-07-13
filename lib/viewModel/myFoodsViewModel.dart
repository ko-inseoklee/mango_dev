import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/model/myFood.dart';
import 'package:mangodevelopment/view/refrigerator/addFoodDirect.dart';

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
        .collection('refrigerator')
        .doc(refID)
        .collection('foods')
        .get();

    data.docs.forEach((element) {
      this.foods!.add(TemporaryFood.fromSnapshot(element.data()));
    });

    return this.foods!;
  }

  Future<void> addFoods(String refID, List<TemporaryFood> foods) async {
    for (TemporaryFood food in foods) {
      await FirebaseFirestore.instance
          .collection('refrigerator')
          .doc(refID)
          .collection('foods')
          .doc('${food.name}-${food.registrationDay}')
          .set({
        'name': food.name,
        'category': food.category,
        'number': food.number,
        'storeType': food.method,
        'displayType': food.displayType,
        'shelfLife': food.shelfLife,
        'registrationDay': food.registrationDay,
      });
    }
  }

  List<TemporaryFood> sortByStoreType(
      List<TemporaryFood> foods, int storeType) {
    List<TemporaryFood> _tempFood = [];

    foods.forEach((element) {
      if (element.method == storeType) {
        _tempFood.add(element);
      }
    });

    return _tempFood;
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
