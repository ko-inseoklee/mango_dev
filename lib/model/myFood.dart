class MyFood {
  final String foodName;
  final String foodID;
  String category;
  int num;
  int storeType;
  bool status;
  DateTime shelfLife;
  final DateTime registrationDay;

  MyFood(this.foodName, this.foodID, String category, int num, int storeType,
      bool status, DateTime shelfLife, this.registrationDay)
      : category = category,
        num = num,
        status = status,
        shelfLife = shelfLife,
        storeType = storeType;
}
