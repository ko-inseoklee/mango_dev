import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Food {
  // 임시로 final  제거.
  String fId;
  final String rId;
  int idx;

  // 삭제 or not
  bool status;
  String name;
  int number;
  String category;

  // 냉장, 냉동, 실온
  int method;

  // 유통기한, 표시기준
  bool displayType;
  DateTime shelfLife;
  DateTime registrationDay;

  DateTime alarmDay;

  // IS - for card status / 0: Normal, 1: Over, 2: D-Day, 3: Stale
  int cardStatus;

  Food(
      {required this.fId,
      required this.rId,
      required int index,
      required bool status,
      required String name,
      required int num,
      required String category,
      required int method,
      required bool displayType,
      required DateTime shelfLife,
      required DateTime registrationDay,
      required DateTime alarmDate,
      required int cardStatus})
      : idx = index,
        status = status,
        name = name,
        number = num,
        category = category,
        method = method,
        displayType = displayType,
        shelfLife = shelfLife,
        registrationDay = registrationDay,
        alarmDay = alarmDate,
        cardStatus = cardStatus;

  String get getName => name;


  Food.init()
      : rId = Uuid().v4(),
        fId = Uuid().v4(),
        idx = 0,
        status = true,
        name = '',
        number = 1,
        category = '-',
        method = 0,
        displayType = true,
        shelfLife = DateTime.now(),
        registrationDay = DateTime.now(),
        alarmDay = DateTime.now(),
        cardStatus = -1;

  Food.fromSnapshot(Map<String, dynamic> food)
      : rId = food['rId'],
        fId = food['fId'],
        idx = 0,
        status = true,
        name = food['name'],
        number = food['number'],
        category = food['category'],
        method = food['storeType'],
        shelfLife = food['shelfLife'].toDate(),
        registrationDay = food['registrationDay'].toDate(),
        displayType = food['displayType'],
        alarmDay = food['alarmDay'].toDate(),
        cardStatus = food['cardStatus'];

  Future<Food> postFood(String docID) async {
    Food food;
    var snap = await FirebaseFirestore.instance
        .collection('myFood')
        .doc(docID)
        .get()
        .then((value) => value.data());
    food = Food.fromSnapshot(snap!);
    return food;
  }
}
