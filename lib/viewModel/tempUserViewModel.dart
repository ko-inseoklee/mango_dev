import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

import '../model/tempUser.dart';

class TempUserViewModel extends GetxController {
  TempUser user = TempUser.init(uid: '', refID: '');

  Future<void> FindUserSnapshot(String uid) async {
    await FirebaseFirestore.instance
        .collection('temp_user')
        .doc(uid)
        .get()
        .then((value) => TempUser.fromSnapshot(value));
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
