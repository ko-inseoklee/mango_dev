import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/refrigerator.dart';

CollectionReference refCollection =
    FirebaseFirestore.instance.collection('refrigerator');

class RefrigeratorViewModel extends GetxController {
  var refrigerator = Refrigerator.init(refID: 'test').obs;

  get refID => this.refrigerator.value.refID;

  Future<void> FindRefrigeratorSnapshot(String uid) async {
    await refCollection.doc(uid).get().then((value) {
      Map<String, dynamic> data = value.data() as Map<String, dynamic>;
      this.refrigerator = Refrigerator.fromSnapshot(data).obs;
      update();
      // print("refID == ${data['refID']}");
    });
    update();
  }
}
