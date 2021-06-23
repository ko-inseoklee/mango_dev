import 'package:cloud_firestore/cloud_firestore.dart';

class TempUser {
  final String uid;
  final String refID;

  TempUser.init({required String uid, required String refID})
      : this.uid = uid,
        this.refID = uid;

  TempUser.fromSnapshot(DocumentSnapshot snapshot)
      : uid = snapshot.get('uid'),
        refID = snapshot.get('refID');
}
