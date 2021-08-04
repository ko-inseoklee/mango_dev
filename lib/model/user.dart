import 'package:cloud_firestore/cloud_firestore.dart';

//Field name for User document.
final isFrozenAlarm = 'frozen_is_shelf';
final frozenAlarmTime = 'frozen_shelf_life_alarm';
final isRefAlarm = 'refrigeration_is_shelf';
final refAlarmTime = 'refrigeration_shelf_life_alarm';
final isRTAlarm = 'room_temp_is_shelf';
final rTAlarmTime = 'room_temp_shelf_life_alarm';

class User {
  String userID;
  DateTime creationTime;
  String refrigeratorID;
  bool isAlarmOn;
  int refrigerationAlarm;
  bool isRefShelf;
  int frozenAlarm;
  bool isFroShelf;
  int roomTempAlarm;
  bool isRTShelf;
  DateTime lastSignIn;
  String profileImageReference;
  String userName;
  String tokens;
  // Future<List<String>> friendList;

  //final DocumentReference reference;

  User.init({
    required String userID,
    required DateTime creationTime,
    required String refrigeratorID,
    required bool isAlarmOn,
    required int refrigerationAlarm,
    required bool isRefShelf,
    required int frozenAlarm,
    required bool isFroShelf,
    required int roomTempAlarm,
    required bool isRTShelf,
    required DateTime lastSignIn,
    required String profileImageReference,
    required String userName,
    required String tokens,
    // required Future<List<String>> friendList,
    //required DocumentReference reference
  })  : this.userID = userID,
        this.creationTime = creationTime,
        this.refrigeratorID = refrigeratorID,
        this.isAlarmOn = isAlarmOn,
        this.refrigerationAlarm = refrigerationAlarm,
        this.isRefShelf = isRefShelf,
        this.frozenAlarm = frozenAlarm,
        this.isFroShelf = isFroShelf,
        this.roomTempAlarm = roomTempAlarm,
        this.isRTShelf = isRTShelf,
        this.lastSignIn = lastSignIn,
        this.profileImageReference = profileImageReference,
        this.userName = userName,
        this.tokens = tokens;
        // this.friendList = friendList;

  //this.reference = reference;

  User.fromSnapshot(DocumentSnapshot snapshot)
      : userID = snapshot.get('userID'),
        creationTime = snapshot.get('creationTime'),
        refrigeratorID = snapshot.get('refrigeratorID'),
        isAlarmOn = snapshot.get('isAlarmOn'),
        refrigerationAlarm = snapshot.get('refrigerationAlarm'),
        isRefShelf = snapshot.get('isRefShelf'),
        frozenAlarm = snapshot.get('frozenAlarm'),
        isFroShelf = snapshot.get('isFroShelf'),
        roomTempAlarm = snapshot.get('roomTempAlarm'),
        isRTShelf = snapshot.get('isRTShelf'),
        lastSignIn = snapshot.get('lastSignIn'),
        profileImageReference = snapshot.get('profileImageReference'),
        userName = snapshot.get('userName'),
        tokens = snapshot.get('tokens');
        // friendList = loadFriendList(snapshot);

        // friendList =
        //     snapshot.reference.collection('FriendList').get().then((value) {
        //   List<String> _list = [];
        //   value.docs.forEach((element) {
        //     _list.add(element.get('userID'));
        //   });
        //   print('LIST = ' + _list.toList().toString() + '!!' );
        //   return _list;
        // });

}
