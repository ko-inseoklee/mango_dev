import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatRoomViewModel extends GetxController {
  void AccessChatRoom(String chatID, String uid) {
    FirebaseFirestore.instance.collection('user').doc(uid).collection(
        'chatList').where('chatID', isEqualTo: chatID).get().then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance.collection('user').doc(uid).collection(
            'chatList').doc(element.id).update({
          'lastAccess': Timestamp.now(),
        });
      });
    });
    // FirebaseFirestore.instance.collection('chatRooms').doc(chatID).update({
    //   'lastAccess': Timestamp.now(),
    // });
  }
}
