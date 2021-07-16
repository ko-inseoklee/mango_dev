import 'package:cloud_firestore/cloud_firestore.dart';

class Refrigerator {
  String refID;
  String uID;

  Refrigerator.init({required String uID, required String refID})
      : this.refID = refID,
        this.uID = uID;

  Refrigerator.fromSnapshot(Map<String, dynamic> data)
      : refID = data['refID'],
        uID = data['userID'];
}
