import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatRoomViewModel extends GetxController {
  void AccessChatRoom(String chatID, String uid, String userName) {
    // FirebaseFirestore.instance.collection('chatRooms').doc(chatID).update({
    //   'ownerName': _post.owner.userName,
    //   'ownerID': _post.owner.userID,
    //   'profileImageReference': _post.owner.profileImageReference,
    // });
    // print("ACCESS CHAT ROOM");

    // FirebaseFirestore.instance.collection('chatRooms').doc(chatID).collection(
    //     'messages').get().then((value){
    //       value.docs.forEach((element) {
    //
    //         // print(element.get('from'));
    //         // print(element.get('to'));
    //       });
    // });

    FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .collection('chatList')
        .where('chatID', isEqualTo: chatID)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .collection('chatList')
            .doc(element.id)
            .update({
          'lastAccess': Timestamp.now(),
        }).then((_) {
          FirebaseFirestore.instance
              .collection('chatRooms')
              .doc(chatID)
              .collection('messages')
              .where('to', isEqualTo: uid)
              .get()
              .then((value) {
            value.docs.forEach((element) {
              element.reference.update({
                'read': true,
              });
            });
          });
        });
      });
    });
  }
}
