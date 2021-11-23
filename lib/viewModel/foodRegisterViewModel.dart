import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:uuid/uuid.dart';

String quickDBCollection = '';

class FoodRegisterViewModel extends GetxController{
  var tempFoodWithQuick = [].obs;
  var addFoodQuick = [].obs;

  addFoodListQuick({required String foodName}){
    tempFoodWithQuick.add(foodName);
  }

  removeFoodListQuick({required String foodName}){
    tempFoodWithQuick.remove(foodName);
  }

  carryToRegisterPage(String rID) async {
    FirebaseFirestore.instance.collection(quickDBCollection).get().then((value) {
      value.docs.forEach((element) {
        if(tempFoodWithQuick.contains(element.data()['name'])){
          String fID = Uuid().v4();
          Food temp = Food.fromSnapshot(element.data());
          addFoodQuick.add(temp);
        }
      });
    });

    return addFoodQuick;
  }
}

