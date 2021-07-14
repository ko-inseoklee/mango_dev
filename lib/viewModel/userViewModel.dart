import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../model/user.dart';

class UserViewModel extends GetxController {
  var isImageLoading = false.obs;
  var imageURL = '';

  var user = User.init(
    userID: '',
    creationTime: DateTime.now(),
    refrigeratorID: '',
    refrigerationAlarm: 0,
    isRefShelf: false,
    frozenAlarm: 0,
    isFroShelf: false,
    roomTempAlarm: 0,
    isRTShelf: false,
    lastSignIn: DateTime.now(),
    profileImageReference: '',
    userName: '',
    tokens: '',
  ).obs;

  String get userID => this.user.value.userID;

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
      'userName': this.user.value.userName,
      'profileImageReference': this.user.value.profileImageReference,
      'refrigerationAlarm': this.user.value.refrigerationAlarm,
      'frozenAlarm': this.user.value.frozenAlarm,
      'roomTempAlarm': this.user.value.roomTempAlarm
    });
  }

  //Making 'User' class (local) from Firebase Data
  Future<void> setUserInfo(String uid) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .get()
        .then((value) {
      Map<String, dynamic> data = value.data() as Map<String, dynamic>;
      this.user.value.refrigerationAlarm = data['refrigerationAlarm'];
      this.user.value.frozenAlarm = data['frozenAlarm'];
      this.user.value.roomTempAlarm = data['roomTempAlarm'];
      this.user.value.profileImageReference = data['profileImageReference'];
      this.user.value.userName = data['userName'];
      this.user.value.userID = data['userID'];
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
  ) async {
    await FirebaseFirestore.instance.collection('user').doc(userID).set({
      'userID': userID,
      'creationTime': creationTime,
      'refrigeratorID': refrigeratorID,
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
    });

    this.user.value.refrigerationAlarm = refrigerationAlarm;
    this.user.value.frozenAlarm = frozenAlarm;
    this.user.value.roomTempAlarm = roomTempAlarm;
    this.user.value.profileImageReference = profileImageReference;
    this.user.value.userName = userName;
  }

// void uploadImage(ImageSource imageSource) async{
//   try{
//     final pickedFile = await ImagePicker().getImage(source: imageSource);
//     isImageLoading(true);
//     if(pickedFile != null) {
//       var response = await
//     }
//   } finally{
//     isImageLoading(false);
//   }
// }
}
