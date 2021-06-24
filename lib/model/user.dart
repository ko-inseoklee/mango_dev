import 'package:cloud_firestore/cloud_firestore.dart';

//Field name for User document.
final isFrozenAlarm = 'frozen_is_shelf';
final frozenAlarmTime = 'frozen_shelf_life_alarm';
final isRefAlarm = 'refrigeration_is_shelf';
final refAlarmTime = 'refrigeration_shelf_life_alarm';
final isRTAlarm = 'room_temp_is_shelf';
final rTAlarmTime = 'room_temp_shelf_life_alarm';

class User {
  final String userID;
  final DateTime creationTime;
  final String refrigeratorID;
  int refrigerationAlarm;
  bool isRefShelf;
  int frozenAlarm;
  bool isFroShelf;
  int roomTempAlarm;
  bool isRTShelf;
  DateTime lastSignIn;
  String profileImageReference;
  String userName;
  //final DocumentReference reference;

  User.init(
      {required String userID,
      required DateTime creationTime,
      required String refrigeratorID,
      required int refrigerationAlarm,
      required bool isRefShelf,
      required int frozenAlarm,
      required bool isFroShelf,
      required int roomTempAlarm,
      required bool isRTShelf,
      required DateTime lastSignIn,
      required String profileImageReference,
      required String userName,
      //required DocumentReference reference
      })
      : this.userID = userID,
        this.creationTime = creationTime,
        this.refrigeratorID = refrigeratorID,
        this.refrigerationAlarm = refrigerationAlarm,
        this.isRefShelf = isRefShelf,
        this.frozenAlarm = frozenAlarm,
        this.isFroShelf = isFroShelf,
        this.roomTempAlarm = roomTempAlarm,
        this.isRTShelf = isRTShelf,
        this.lastSignIn = lastSignIn,
        this.profileImageReference = profileImageReference,
        this.userName = userName;
        //this.reference = reference;

  User.fromSnapshot(DocumentSnapshot snapshot)
  : userID = snapshot.get('userID'),
  creationTime = snapshot.get('creationTime'),
  refrigeratorID = snapshot.get('refrigeratorID'),
  refrigerationAlarm = snapshot.get('refrigerationAlarm'),
  isRefShelf = snapshot.get('isRefShelf'),
  frozenAlarm = snapshot.get('frozenAlarm'),
  isFroShelf = snapshot.get('isFroShelf'),
  roomTempAlarm = snapshot.get('roomTempAlarm'),
  isRTShelf = snapshot.get('isRTShelf'),
  lastSignIn = snapshot.get('lastSignIn'),
  profileImageReference = snapshot.get('profileImageReference'),
  userName = snapshot.get('userName');
  //reference = snapshot.get('reference');

}
