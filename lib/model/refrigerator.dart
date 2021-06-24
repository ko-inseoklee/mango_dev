import 'package:cloud_firestore/cloud_firestore.dart';

class Refrigerator {
  final String refID;

  Refrigerator.init({required String refID}) : this.refID = refID;

  Refrigerator.fromSnapshot(Map<String, dynamic> data) : refID = data['refID'];
}
