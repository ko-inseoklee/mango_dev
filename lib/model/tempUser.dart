import 'package:cloud_firestore/cloud_firestore.dart';

class TempUser {
  final String uid;
  String name;
  final String refID;

  TempUser.init(
      {required String uid, required String name, required String refID})
      : this.uid = uid,
        name = name,
        this.refID = refID;

  TempUser.fromSnapshot(DocumentSnapshot snapshot)
      : uid = snapshot.get('uid'),
        name = snapshot.get('name'),
        refID = snapshot.get('refID');
}
