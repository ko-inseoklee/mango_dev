import 'package:mangodevelopment/model/food.dart';

class ShowFoods {
  List<List<TemporaryFood>> showRefFoods = [];
  List<TemporaryFood> canModifyFoods = [];

  // 0-2 : 한눈에 보기 , 3-14: 카테고리별 보기, 15-20: 유통기한별 보기
  List<bool> showInOnceIsFolds = [];

  int foodsLength;
  int currentTab;
  bool allFold;
  bool isModify;

  ShowFoods.init(
      {required List<List<TemporaryFood>> foodList,
      required List<TemporaryFood> canModifyFoods,
      required bool allFold,
      required bool isModify,
      required int foodsLength,
      required int currentTab,
      required List<bool> isFolds})
      : showRefFoods = foodList,
        canModifyFoods = canModifyFoods,
        allFold = allFold,
        currentTab = currentTab,
        foodsLength = foodsLength,
        isModify = isModify,
        showInOnceIsFolds = isFolds;
}
