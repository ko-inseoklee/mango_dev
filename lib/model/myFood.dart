class MyFood {
  final String foodName;
  final String foodID;
  String category;
  int num = 0;
  int storeType = 0;

  MyFood(this.foodName, String category, int num, int storeType, this.foodID)
      : category = category,
        num = num,
        storeType = storeType;
}
