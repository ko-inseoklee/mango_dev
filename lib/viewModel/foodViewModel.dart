import 'package:uuid/uuid.dart';

class TemporaryFood {
  final String fId;
  final String rId;
  int idx;
  //
  bool status;
  String name;
  int number;
  String category;
  // 냉장, 냉동, 실온
  int method;
  bool displayType;
  // 유통기한, 표시기준
  DateTime shelfLife;
  DateTime registrationDay;

  /*
  0: registerNormal
  1: registerAbnormal
  2: shelfNormal
  3: shelfDDay
  4: shelfOver
  5: isModify
   */
  List<bool> selectedWidget;

  TemporaryFood(
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
      required List<bool> selectedWidget})
      : idx = index,
        status = status,
        name = name,
        number = num,
        category = category,
        method = method,
        displayType = displayType,
        shelfLife = shelfLife,
        registrationDay = registrationDay,
        selectedWidget = selectedWidget;
  String get getName => name;

  TemporaryFood.init()
      : rId = Uuid().v4(),
        fId = Uuid().v4(),
        idx = 0,
        status = true,
        name = '-',
        number = 0,
        category = '-',
        method = 0,
        displayType = true,
        shelfLife = DateTime.now(),
        registrationDay = DateTime.now(),
        selectedWidget = [
          false,
          false,
          false,
          false,
          false,
          false,
        ];

  TemporaryFood.fromSnapshot(Map<String, dynamic> food)
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
        selectedWidget = food['selectedWidget'];
}
