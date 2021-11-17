import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mangodevelopment/model/post.dart';
import '../model/user.dart';

class UserViewModel extends GetxController {
  var isImageLoading = false.obs;
  var imageURL = '';

  //isRefSelf == true => 유통기한기준, == false => 구매일 기준.
  var user = User.init(
    userID: '',
    creationTime: Timestamp.now(),
    refrigeratorID: '1',
    isAlarmOn: true,
    refrigerationAlarm: 0,
    isRefShelf: false,
    frozenAlarm: 0,
    isFroShelf: false,
    roomTempAlarm: 0,
    isRTShelf: false,
    lastSignIn: Timestamp.now(),
    profileImageReference: '',
    userName: '',
    tokens: '',
    phoneNumber: '',
    chatList: [],
    location: GeoPoint(0,0),
  ).obs;

  String get userID => this.user.value.userID;

  set isAlarmOn(bool value) {
    this.user.value.isAlarmOn = value;
    update();
  }

  set refAlarm(int value) {
    this.user.value.refrigerationAlarm = value;
    update();
  }

  set isRefShelf(bool value) {
    this.user.value.isRefShelf = value;
    update();
  }

  set frozenAlarm(int value) {
    this.user.value.frozenAlarm = value;
    update();
  }

  set isFroShelf(bool value) {
    this.user.value.isFroShelf = value;
    update();
  }

  set roomTempAlarm(int value) {
    this.user.value.roomTempAlarm = value;
    update();
  }

  set isRTShelf(bool value) {
    this.user.value.isRTShelf = value;
    update();
  }

  set profileImageReference(String value) {
    this.user.value.profileImageReference = value;
    update();
  }

  set userName(String value) {
    this.user.value.userName = value;
    update();
  }

  Future<void> setUserName(String name) async {
    this.user.value.userName = name;
    update();
  }

  Future<void> setUserProfileImage(String value) async {
    this.user.value.profileImageReference = value;
    update();
  }

  Future<void> findUserSnapshot(String uid) async {
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

  //update Firebase User info from 'User' class (local) Data
  Future<void> updateUserInfo(String uid) async {
    await FirebaseFirestore.instance.collection('user').doc(uid).update({
      'userID': this.user.value.userID,
      'userName': this.user.value.userName,
      'refrigeratorID': this.user.value.refrigeratorID,
      'isAlarmOn': this.user.value.isAlarmOn,
      'profileImageReference': this.user.value.profileImageReference,
      'isRefShelf': this.user.value.isRefShelf,
      'refrigerationAlarm': this.user.value.refrigerationAlarm,
      'isFroShelf': this.user.value.isFroShelf,
      'frozenAlarm': this.user.value.frozenAlarm,
      'isRTShelf': this.user.value.isRTShelf,
      'roomTempAlarm': this.user.value.roomTempAlarm,
      'tokens': this.user.value.tokens,
      'phoneNumber': this.user.value.phoneNumber,
      'location': this.user.value.location,
    });
  }

  Future<void> updateUserName(String uid, String value) async {
    await FirebaseFirestore.instance.collection('user').doc(uid).update({
      'userName': value,
    }).then((val) => this.user.value.userName = value);
  }

  Future<void> updateUserProfileImage(String uid, String value) async {
    await FirebaseFirestore.instance.collection('user').doc(uid).update({
      'profileImageReference': value,
    });
  }

  Future<void> updateUserLocation(String uid, GeoPoint location)async{
    await FirebaseFirestore.instance.collection('user').doc(uid).update({
      'location': location,
    });

  }
  //Making 'User' class (local) from Firebase Data
  Future<void> setUserInfo(String uid) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .get()
        .then((value) {
      if (value.exists) {
        Map<String, dynamic> data = value.data() as Map<String, dynamic>;
        this.user.value.isRefShelf = data['isRefShelf'];
        this.user.value.isFroShelf = data['isFroShelf'];
        this.user.value.isRTShelf = data['isRTShelf'];
        this.user.value.isAlarmOn = data['isAlarmOn'];
        this.user.value.refrigerationAlarm = data['refrigerationAlarm'];
        this.user.value.frozenAlarm = data['frozenAlarm'];
        this.user.value.roomTempAlarm = data['roomTempAlarm'];
        this.user.value.profileImageReference = data['profileImageReference'];
        this.user.value.userName = data['userName'];
        this.user.value.userID = data['userID'];
        this.user.value.refrigeratorID = data['refrigeratorID'];
        this.user.value.phoneNumber = data['phoneNumber'];
        this.user.value.location = data['location'];
      } else {
        print('fail to load..');
      }
    });
  }

  Future<void> makeFriendList(String uid) async {
    FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .collection('FriendList');
  }

  Future<void> makeUserInformation(
      String userID,
      DateTime creationTime,
      String refrigeratorID,
      bool isAlarmOn,
      int refrigerationAlarm,
      bool isRefShelf,
      int frozenAlarm,
      bool isFroShelf,
      int roomTempAlarm,
      bool isRTShelf,
      DateTime lastSignIn,
      String profileImageReference,
      String userName,
      String tokens,
      List<String> chatList,
      String phoneNumber,
      ) async {
    await FirebaseFirestore.instance.collection('user').doc(userID).set({
      'userID': userID,
      'creationTime': creationTime,
      'refrigeratorID': refrigeratorID,
      'isAlarmOn': isAlarmOn,
      'refrigerationAlarm': refrigerationAlarm,
      'isRefShelf': isRefShelf,
      'frozenAlarm': frozenAlarm,
      'isFroShelf': isFroShelf,
      'roomTempAlarm': roomTempAlarm,
      'isRTShelf': isRTShelf,
      'lastSignIn': lastSignIn,
      'profileImageReference': profileImageReference,
      'userName': userName,
      'tokens': tokens,
      'phoneNumber': phoneNumber,
      'chats': [],
      'location': GeoPoint(0,0),
      // TODO: check if the chats beeing created
    });

    this.user.value.isAlarmOn = isAlarmOn;
    this.user.value.refrigerationAlarm = refrigerationAlarm;
    this.user.value.frozenAlarm = frozenAlarm;
    this.user.value.roomTempAlarm = roomTempAlarm;
    this.user.value.profileImageReference = profileImageReference;
    this.user.value.userName = userName;
    this.user.value.phoneNumber = phoneNumber;
    this.user.value.chatList = [];
    this.user.value.location = GeoPoint(0, 0);
  }

  Future<void> addPost(@required Post post) async {
    FirebaseFirestore.instance.collection('post').doc(post.postID).set({
      'foodName': post.foods.name,
      'foodNum': post.foods.number,
      'category': post.foods.category,
      'location': post.owner.location,
      // 'location': GeoPoint(post.owner.location.latitude, post.owner.location.longitude),
      'ownerID': post.owner.userID,
      'ownerName': post.owner.userName,
      'postID': post.postID,
      'profileImageReference': post.owner.profileImageReference,
      'registTime': post.registTime,
      'shelfLife': post.foods.shelfLife,
      'state': post.state,
      'subtitle': post.subtitle,
      'chats': FieldValue.arrayUnion(post.chatList),
    });
  }
}
