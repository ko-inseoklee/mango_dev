import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/view/widget/appBar.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';
import 'package:uuid/uuid.dart';

import '../../color.dart';

final List<Food> quickFoods = [
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '라면',
      num: 1,
      category: '즉석식품',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '계란',
      num: 1,
      category: '우유/유제품',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '김',
      num: 1,
      category: '수산물',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '김치',
      num: 1,
      category: '김치/반찬',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '우유',
      num: 1,
      category: '우유/유제품',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '참치',
      num: 1,
      category: '수산물',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '양파',
      num: 1,
      category: '채소',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '마늘',
      num: 1,
      category: '채소',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '햄',
      num: 1,
      category: '육류',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '닭가슴살',
      num: 1,
      category: '육류',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '대파',
      num: 1,
      category: '채소',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '버터',
      num: 1,
      category: '우유/유제품',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '돼지고기',
      num: 1,
      category: '육류',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '사과',
      num: 1,
      category: '과일',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '고추',
      num: 1,
      category: '채소',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '만두',
      num: 1,
      category: '냉장/냉동식품',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '치즈',
      num: 1,
      category: '우유/유제품',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '닭고기',
      num: 1,
      category: '육류',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '고구마',
      num: 1,
      category: '채소',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '바나나',
      num: 1,
      category: '과일',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '두부',
      num: 1,
      category: '김치/반찬',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '멸치',
      num: 1,
      category: '수산물',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '콩나물',
      num: 1,
      category: '채소',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '소시지',
      num: 1,
      category: '육류',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '샐러드',
      num: 1,
      category: '채소',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '감자',
      num: 1,
      category: '채소',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '햇반',
      num: 1,
      category: '즉석식품',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '파스타면',
      num: 1,
      category: '즉석식품',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '캐첩',
      num: 1,
      category: '조미료/양념',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '마요네즈',
      num: 1,
      category: '조미료/양념',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '참기름',
      num: 1,
      category: '조미료/양념',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '간장',
      num: 1,
      category: '조미료/양념',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '고추장',
      num: 1,
      category: '조미료/양념',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '된장',
      num: 1,
      category: '조미료/양념',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
  Food(
      fId: Uuid().v4(),
      rId: Uuid().v4(),
      index: 0,
      status: true,
      name: '굴소스',
      num: 1,
      category: '조미료/양념',
      method: 0,
      displayType: true,
      shelfLife: DateTime.now(),
      registrationDay: DateTime.now(),
      alarmDate: DateTime.now(),
      cardStatus: -1),
];

//Quick Data 설문 조사 결과를 바탕으로 카테고리 순서를 정함
//카테고리 순서는 다음과 같이 보여주면 된다.
final List<String> categories = [
  "우유/유제품",
  "육류",
  "채소",
  "과일",
  "수산물",
  "조미료/양념",
  "냉장/냉동식품",
  "김치/반찬",
  "즉석식품",
];

List<List<Food>> foodWithCategories = [[],[],[],[],[],[],[],[],[],[],[],[]];
List<Food> addFoodLists = [];

class AddFoodQuickPage extends StatefulWidget {
  @override
  _AddFoodQuickPageState createState() => _AddFoodQuickPageState();
}

class _AddFoodQuickPageState extends State<AddFoodQuickPage> {

  late RefrigeratorViewModel refrigerator;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(foodWithCategories[0].length == 0) {
      categoriesFoods();
    }
    addFoodLists.clear();
  }

  @override
  Widget build(BuildContext context) {
    refrigerator = Get.find<RefrigeratorViewModel>();
    return Scaffold(
        appBar: MangoAppBar(
          title: 'Quick 채우기',
          isLeading: true,
          actions: [TextButton(onPressed: () async {
            if(addFoodLists.length != 0) {
              for(int i = 0; i < addFoodLists.length; i++){
                addFoodLists[i].fId = Uuid().v4();
              }
              await refrigerator.addFoods(addFoodLists).then((value) => Get.back());
            }
            else print("추가할 놈이 없다. 비어있다.");
            }, child: Text("추가"))],
        ),
        body: ListView.builder( // For Categories
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Container(
                  height: ScreenUtil().setHeight(40),
                  width: ScreenUtil().screenWidth,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Color(0xFFE5E5E5),
                      ),
                      color: Color(0xFFF9F8F6)),
                  child: Align(
                      alignment: Alignment.centerLeft, child: Text("    ${categories[index]}")),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder( // For contents in same category
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                      ),
                      itemCount: foodWithCategories[index].length, // TODO. Change This
                      itemBuilder: (BuildContext context, int foodIdx) {
                        return quickFoodCard( idx: index, fIdx: foodIdx,);
                      }),
                ),
              ],
            );
          },
        ));
  }
  void categoriesFoods(){
    for(int i = 0; i < quickFoods.length; i++){
      int idx = categories.indexOf(quickFoods[i].category);
      foodWithCategories[idx].add(quickFoods[i]);
    }
  }
}

class quickFoodCard extends StatefulWidget {
  int index;
  int foodIdx;
  quickFoodCard({Key? key, required int idx, required int fIdx}) : index = idx, foodIdx = fIdx;

  @override
  _quickFoodCardState createState() => _quickFoodCardState();
}

class _quickFoodCardState extends State<quickFoodCard> {
  late bool _isClicked;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isClicked = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        setState(() {
        _isClicked = !_isClicked;
        });
        if(_isClicked){
          addFoodLists.add(foodWithCategories[widget.index][widget.foodIdx]);
        }
        else{
          addFoodLists.remove(foodWithCategories[widget.index][widget.foodIdx]);
        }
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        width: ScreenUtil().setHeight(100),
        decoration: BoxDecoration(
          color: _isClicked? Orange50 : MangoWhite,
          border: Border.all(
            width: 1,
            color: _isClicked? MangoDisabledColorLight : MangoDisabledColor,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(child: Text(foodWithCategories[widget.index][widget.foodIdx].name,style: Theme.of(context).textTheme.subtitle2!.copyWith(color: _isClicked? Orange700 : MangoBlack ),)), //TODO. Change this
      ),
    );
  }
}
