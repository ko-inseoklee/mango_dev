import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/model/post.dart';

class postViewModel extends GetxController {
  FirebaseFirestore mango_dev = FirebaseFirestore.instance;

  var post = Post.init().obs;

  getFriendPostStream(String curr_uid) {
    mango_dev
        .collection('post')
        .where('ownerFriendList', arrayContains: curr_uid)
        .snapshots();
  }
}
