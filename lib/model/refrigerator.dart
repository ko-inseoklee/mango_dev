import 'food.dart';

class Refrigerator {
  String rID;
  String uID;
  List<Food> foods;

  Refrigerator.init(
      {required String rID, required String uID, required List<Food> foods})
      : rID = rID,
        uID = uID,
        foods = foods;
}
