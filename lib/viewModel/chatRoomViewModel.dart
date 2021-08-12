import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatRoomViewModel extends GetxController {
  void AccessChatRoom(String chatID) {
    FirebaseFirestore.instance.collection('chatRooms').doc(chatID).update({
      'lastAccess': Timestamp.now(),
    });
  }
}
