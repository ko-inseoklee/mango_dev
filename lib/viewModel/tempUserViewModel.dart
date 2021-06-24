import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/tempUser.dart';

class TempUserViewModel extends GetxController {
  var user = TempUser.init(uid: '', refID: '').obs;

  Future<void> FindTempUserSnapshot(String uid) async {
    await FirebaseFirestore.instance
        .collection('temp_user')
        .doc(uid)
        .get()
        .then((value) => this.user = TempUser.fromSnapshot(value).obs);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
