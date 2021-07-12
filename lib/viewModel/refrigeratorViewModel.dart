import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/refrigerator/addFoodDirect.dart';
import 'package:mangodevelopment/viewModel/myFoodsViewModel.dart';

import '../main.dart';
import '../model/refrigerator.dart';

CollectionReference refCollection =
    FirebaseFirestore.instance.collection('refrigerator');

class RefrigeratorViewModel extends GetxController {
  var refrigerator = Refrigerator.init(refID: '123456').obs;
  var myFoodsViewModel = MyFoodsViewModel.init().obs;

  get refID => this.refrigerator.value.refID;

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
