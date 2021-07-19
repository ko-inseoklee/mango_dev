import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/refrigerator/addFoodDirect.dart';
import 'package:mangodevelopment/viewModel/myFoodsViewModel.dart';

import '../main.dart';
import '../model/refrigerator.dart';
import '../model/food.dart';

CollectionReference refCollection =
    FirebaseFirestore.instance.collection('refrigerator');

class RefrigeratorViewModel extends GetxController {
  var refrigerator = Refrigerator.init(refID: '', uID: '').obs;
  var myFoodsViewModel = MyFoodsViewModel.init().obs;

  Future<void> createRefrigeratorID(String uid, String rid) async {
    await FirebaseFirestore.instance.collection('refrigerator').doc(rid).set({
      'refID': rid,
      'userID': uid,
    });
  }

  // RefrigeratorViewModel.fromUser(String uid,String rid):this.refrigerator = this.loadRefrigerator(rID)

  // RefrigeratorViewModel.loadFromUser(String rID):

  Future<void> loadRefrigerator(String rID) async {
    await FirebaseFirestore.instance
        .collection('refrigerator')
        .doc(rID)
        .get()
        .then((value) {
      if (value.exists) {
        this.refrigerator.value.uID = value.data()!['userID'];
        this.refrigerator.value.refID = value.data()!['refID'];
      } else {
        print('load failed');
      }
    });

    // this.refrigerator = Refrigerator.fromSnapshot(data.data()!).obs;
    update();
  }

  get refID => this.refrigerator.value.refID;

  Future<void> deleteFoods(List<String> foods) async {
    for (var food in foods) {
      await FirebaseFirestore.instance
          .collection('myFood')
          .doc(food)
          .delete()
          .then((value) => print('success to delete'));
    }
  }

  Future<void> loadFoods() async {
    this.myFoodsViewModel.value.foods!.clear();
    List<TemporaryFood> _foods = [];

    _foods = await myFoodsViewModel.value.loadFoods(refID);
    myFoodsViewModel.value.foods = _foods.obs;
    update();
  }

  Future<void> FindRefrigeratorSnapshot(String uid) async {
    await refCollection.doc(uid).get().then((value) {
      Map<String, dynamic> data = value.data() as Map<String, dynamic>;
      this.refrigerator = Refrigerator.fromSnapshot(data).obs;
      update();
      print("refID == ${data['refID']}");
    });
    update();
  }
}
