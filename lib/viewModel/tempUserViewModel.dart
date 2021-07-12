import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/tempUser.dart';

class TempUserViewModel extends GetxController {
  var user = TempUser.init(uid: '1234', refID: '1234', name: 'inseok').obs;

  Future<void> FindTempUserSnapshot(String uid) async {
    await FirebaseFirestore.instance
        .collection('temp_user')
        .doc(uid)
        .get()
        .then((value) => this.user = TempUser.fromSnapshot(value).obs);
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
