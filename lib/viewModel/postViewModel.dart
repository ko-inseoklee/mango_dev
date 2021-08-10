import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/model/post.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

class postViewModel extends GetxController {
  FirebaseFirestore mango_dev = FirebaseFirestore.instance;
  UserViewModel userViewModelController = Get.find<UserViewModel>();

  var postList = [].obs;

  late List<Post> posts;

  postViewModel() {
    posts = [];
  }

  postViewModel.init() {
    posts = [];
  }

  loadPosts() async {
    await mango_dev
        .collection('post')
        .where('ownerFriendList',
            arrayContains: userViewModelController.user.value.userID)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        posts.add(Post.fromSnapshot(element.data()));

      });
      print('loading post.. ${posts[0].postID} / ${posts[1].postID} / ${posts[2].postID}');
    });

    return posts;
    // update();
  }
}
