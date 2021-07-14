import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class FriendListViewModel extends GetxController {
  FirebaseFirestore mango_dev = FirebaseFirestore.instance;

  Future<void> addFriend(
      String curr_uid, String curr_name, String uid, String name) async {
    if (curr_uid == uid) {
      print('자기를 추가할 수 없습니다');
      // TODO: alert 창 띄우기
      return;
    }

    var check = await mango_dev
        .collection('user')
        .doc(curr_uid)
        .collection('FriendList')
        .where('userID', isEqualTo: uid)
        .limit(1)
        .get();

    List<DocumentSnapshot> documents = check.docs;

    //이미 등록된 친구 일 경우 `snackbar` return
    if (documents.length > 0) {
      return Get.snackbar('친구 추가 실패', '이미 등록된 친구입니다.');
    }
    var myNameList = [];
    var otherNameList = [];

    for (int i = 0; i < name.length; i++)
      otherNameList.add(name.substring(0, i + 1));

    for (int i = 0; i < curr_name.length; i++)
      myNameList.add(curr_name.substring(0, i + 1));

    // print(myNameList);
    // print(otherNameList);

    var myToken;
    var friendToken;
    await mango_dev
        .collection('user')
        .doc(curr_uid)
        .get()
        .then((value) => myToken = value.data()!['tokens']);
    await mango_dev
        .collection('user')
        .doc(uid)
        .get()
        .then((value) => friendToken = value.data()!['tokens']);

    // 내 친구 목록에 상대방 추가
    await mango_dev
        .collection('user')
        .doc(curr_uid)
        .collection('FriendList')
        .add({
      'userName': name,
      'userID': uid,
      'tokens': friendToken,
      'caseNumber': otherNameList.length,
      'case': FieldValue.arrayUnion(otherNameList)
    }).then((_) {
      print('success');
    }).catchError((_) {
      print('error');
    });

    // 상대방 친구 목록에 나 추가
    await mango_dev
        .collection('user')
        .doc(uid)
        .collection('FriendList')
        .add({
          'userName': curr_name,
          'userID': curr_uid,
          'tokens': myToken,
          'caseNumber': myNameList.length,
          'case': FieldValue.arrayUnion(myNameList)
        })
        .then((value) => print('success2'))
        .catchError((_) {
          print('error2');
        });

    return Get.snackbar('친구 추가 완료', name + '님이 친구로 추가되었습니다');
  }

  void deleteFriend(String curr_uid, String uid) {
    var myfriendList =
        mango_dev.collection('user').doc(curr_uid).collection('FriendList');

    var otherfriendList =
        mango_dev.collection('user').doc(uid).collection('FriendList');

    //delete from my friend list
    myfriendList.where('userID', isEqualTo: uid).get().then((value) {
      value.docs.forEach((element) {
        myfriendList
            .doc(element.id)
            .delete()
            .then((value) => print('deleted1'));
      });
    });

    //delete from others friend list
    otherfriendList.where('userID', isEqualTo: curr_uid).get().then((value) {
      value.docs.forEach((element) {
        otherfriendList
            .doc(element.id)
            .delete()
            .then((value) => print('deleted2'));
      });
    });
  }
}
