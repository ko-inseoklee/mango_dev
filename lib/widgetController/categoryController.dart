List<String> categories = [
  '과일',
  '채소',
  '우유/유제품',
  '수산물',
  '곡물',
  '조미료/양념',
  '육류',
  '냉장/냉동식품',
  '베이커리/과자',
  '김치/반찬',
  '즉석식품',
  '물/음료'
];

List<String> categoryImg = [
  'Fruits.png',
  'Vegetables.png',
  'MilkNDairyProducts.png',
  'AquaticProducts.png',
  'Grains.png',
  'Seasonings.png',
  'MeatEggs.png',
  'RefrigeratedFrozenFoods.png',
  'Bakery.png',
  'KimchiSideDishes.png',
  'RamenInstantFoods.png',
  'WaterCoffeDrinks.png'
];

int translateToKo(String category) {
  return categories.indexOf(category);
}

int translateToEn(String category) {
  return categoryImg.indexOf(category);
}
