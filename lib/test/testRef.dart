import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TestRef {
  String rID;
  String uID;

  TestRef.init({required String rID, required String uID})
      : rID = rID,
        uID = uID;
}

class TestRefViewModel extends GetxController {
  var ref = new TestRef.init(rID: '', uID: '').obs;

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
}
