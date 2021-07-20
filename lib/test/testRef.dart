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
    print("load start: rid == $rID");

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
        print('success in the test Ref == ${ref.value.rID}');
      } else {
        print('Load Fail..');
      }
    });
  }

  Future<void> createRefrigeratorID(String uid, String rid) async {
    await FirebaseFirestore.instance.collection('refrigerator').doc(rid).set({
      'refID': rid,
      'userID': uid,
    });
  }
}
