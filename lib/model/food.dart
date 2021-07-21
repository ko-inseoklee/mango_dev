import 'package:uuid/uuid.dart';

class TemporaryFood {
  final String fId;
  final String rId;
  int idx;
  // 삭제 or not
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

  //For making proper widget.
  bool registerNormal;
  bool registerRefAbnormal;
  bool registerFroAbnormal;
  bool registerRTAbnormal;
  bool shelfNormal;
  bool shelfDDay;
  bool shelfOver;
  bool isModify;
  /*
  0: registerNormal
  1: registerRefAbnormal
  2: registerFroAbnormal
  3: registerRTAbnormal
  4: shelfNormal
  5: shelfDDay
  6: shelfOver
  7: isModify
   */

  TemporaryFood({
    required this.fId,
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
    required bool registerNormal,
    required bool registerRefAbnormal,
    required bool registerFroAbnormal,
    required bool registerRTAbnormal,
    required bool shelfNormal,
    required bool shelfDDay,
    required bool shelfOver,
    required bool isModify,
  })  : idx = index,
        status = status,
        name = name,
        number = num,
        category = category,
        method = method,
        displayType = displayType,
        shelfLife = shelfLife,
        registrationDay = registrationDay,
        registerNormal = registerNormal,
        registerRefAbnormal = registerRefAbnormal,
        registerFroAbnormal = registerFroAbnormal,
        registerRTAbnormal = registerRTAbnormal,
        shelfNormal = shelfNormal,
        shelfDDay = shelfDDay,
        shelfOver = shelfOver,
        isModify = isModify;
  String get getName => name;

  TemporaryFood.init()
      : rId = Uuid().v4(),
        fId = Uuid().v4(),
        idx = 0,
        status = true,
        name = '-',
        number = 1,
        category = '-',
        method = 0,
        displayType = true,
        shelfLife = DateTime.now(),
        registrationDay = DateTime.now(),
        registerNormal = false,
        registerRefAbnormal = false,
        registerFroAbnormal = false,
        registerRTAbnormal = false,
        shelfNormal = false,
        shelfDDay = false,
        shelfOver = false,
        isModify = false;

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
        registerNormal = food['registerNormal'],
        registerRefAbnormal = food['registerRefAbnormal'],
        registerFroAbnormal = food['registerFroAbnormal'],
        registerRTAbnormal = food['registerRTAbnormal'],
        shelfNormal = food['shelfNormal'],
        shelfDDay = food['shelfDDay'],
        shelfOver = food['shelfOver'],
        isModify = food['isModify'];
}
