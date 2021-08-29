import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatRoomViewModel extends GetxController {
  void AccessChatRoom(String chatID, String uid) {
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
    // FirebaseFirestore.instance.collection('chatRooms').doc(chatID).update({
    //   'lastAccess': Timestamp.now(),
    // });
  }
}
