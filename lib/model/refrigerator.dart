import 'food.dart';

class Refrigerator {
  String rID;
  String uID;
  List<Food> refrigerationFoods;
  List<Food> roomTempFoods;
  List<Food> frozenFoods;

  Refrigerator.init(
      {required String rID,
      required String uID,
      required List<Food> refFoods,
      required List<Food> rTFoods,
      required List<Food> froFoods})
      : rID = rID,
        uID = uID,
        refrigerationFoods = refFoods,
        roomTempFoods = rTFoods,
        frozenFoods = froFoods;
}
