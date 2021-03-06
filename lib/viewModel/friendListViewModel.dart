import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

class FriendListViewModel extends GetxController {
  FirebaseFirestore mango_dev = FirebaseFirestore.instance;
  UserViewModel userViewModelController = Get.find<UserViewModel>();

  Future<void> addFriend(String curr_uid, String curr_name, String uid,
      String name, String img) async {
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
    await mango_dev.collection('user').doc(curr_uid).update({
      'friends': FieldValue.arrayUnion([uid])
    });

    await mango_dev
        .collection('user')
        .doc(curr_uid)
        .collection('FriendList')
        .add({
      'userName': name,
      'userID': uid,
      'tokens': friendToken,
      'caseNumber': otherNameList.length,
      'case': FieldValue.arrayUnion(otherNameList),
      'profImgRef': userViewModelController.user.value.profileImageReference
    }).then((_) {
      print('success');
    }).catchError((_) {
      print('error');
    });

    // 상대방 친구 목록에 나 추가
    await mango_dev.collection('user').doc(uid).update({
      'friends': FieldValue.arrayUnion([curr_uid])
    });

    await mango_dev
        .collection('user')
        .doc(uid)
        .collection('FriendList')
        .add({
          'userName': curr_name,
          'userID': curr_uid,
          'tokens': myToken,
          'caseNumber': myNameList.length,
          'case': FieldValue.arrayUnion(myNameList),
          'profImgRef': img
        })
        .then((value) => print('success2'))
        .catchError((_) {
          print('error2');
        });

    // post의 friend list 에 추가
    await mango_dev
        .collection('post')
        .where('ownerID', isEqualTo: uid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.update({
          'ownerFriendList': FieldValue.arrayUnion([curr_uid])
        });
      });
    });

    await mango_dev
        .collection('post')
        .where('ownerID', isEqualTo: curr_uid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.update({
          'ownerFriendList': FieldValue.arrayUnion([uid])
        });
      });
    });

    // sendFriendRequest(friendToken, curr_name);

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

    mango_dev.collection('user').doc(curr_uid).update({
      'friends': FieldValue.arrayRemove([uid])
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

    mango_dev.collection('user').doc(uid).update({
      'friends': FieldValue.arrayRemove([curr_uid])
    });

    // post 친구목록에서 삭제
     mango_dev
        .collection('post')
        .where('ownerID', isEqualTo: uid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.update({
          'ownerFriendList': FieldValue.arrayRemove([curr_uid])
        });
      });
    });

     mango_dev
        .collection('post')
        .where('ownerID', isEqualTo: curr_uid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.update({
          'ownerFriendList': FieldValue.arrayRemove([uid])
        });
      });
    });

  }
}
