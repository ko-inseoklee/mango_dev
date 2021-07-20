import 'package:mangodevelopment/model/food.dart';

class ShowFoods {
  List<List<TemporaryFood>> showRefFoods = [];

  // 0-2 : 한눈에 보기 , 3-14: 카테고리별 보기, 15-20: 유통기한별 보기
  List<bool> showInOnceIsFolds = [];

  int foodsLength;

  ShowFoods.init(
      {required List<List<TemporaryFood>> foodList,
      required int foodsLength,
      required List<bool> isFolds})
      : showRefFoods = foodList,
        foodsLength = foodsLength,
        showInOnceIsFolds = isFolds;
}
