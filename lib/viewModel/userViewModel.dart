import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../model/user.dart';

class UserViewModel extends GetxController{

  var user = User.init(userID: '', creationTime: DateTime.now(), refrigeratorID: '', refrigerationAlarm: 0, isRefShelf: false, frozenAlarm: 0, isFroShelf: false, roomTempAlarm: 0, isRTShelf: false, lastSignIn: DateTime.now(), profileImageReference: '', userName: '').obs;

  String get userID => this.user.value.userID;

  set refAlarm(int value){
    this.user.value.refrigerationAlarm = value;
    update();
  }

  set isRefShelf(bool value){
    this.user.value.isRefShelf = value;
    update();
  }

  set frozenAlarm(int value){
    this.user.value.frozenAlarm = value;
    update();
  }

  set isFroShelf(bool value){
    this.user.value.isFroShelf = value;
    update();
  }

  set roomTempAlarm(int value){
    this.user.value.roomTempAlarm = value;
    update();
  }

  set isRTShelf(bool value){
    this.user.value.isRTShelf = value;
    update();
  }

  set profileImageReference(String value){
    this.user.value.profileImageReference = value;
    update();
  }

  set userName(String value){
    this.user.value.userName = value;
    update();
  }

  Future<void> findUserSnapshot(String uid) async{
    await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .get()
        .then((value) => this.user = User.fromSnapshot(value).obs);
    update();
  }

  Future<void> deleteUser(String uid) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .delete()
        .then((value) => print("delete success"));
  }

  Future<void> makeUserInformation(
      String userID,
      DateTime creationTime,
      String refrigeratorID,
      int refrigerationAlarm,
      bool isRefShelf,
      int frozenAlarm,
      bool isFroShelf,
      int roomTempAlarm,
      bool isRTShelf,
      DateTime lastSignIn,
      String profileImageReference,
      String userName
      ) async {
    await FirebaseFirestore.instance.collection('user').doc(userID).set({
    'userID': userID,
    'creationTime' : creationTime,
    'refrigeratorID' : refrigeratorID,
    'refrigerationAlarm' : refrigerationAlarm,
    'isRefShelf' : isRefShelf,
    'frozenAlarm' : frozenAlarm,
    'isFroShelf' : isFroShelf,
    'roomTempAlarm' : roomTempAlarm,
    'isRTShelf' : isRTShelf,
    'lastSignIn' : lastSignIn,
    'profileImageReference' : profileImageReference,
    'userName' : userName
    });
  }
}