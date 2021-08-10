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

  // getFriendPost(String currUid) async {
  //   await mango_dev
  //       .collection('post')
  //       .where('ownerFriendList',
  //           arrayContains: userViewModelController.user.value.userID)
  //       .get()
  //       .then((value) {
  //     if (value.size > 0) {
  //       List<Post> posts = [];
  //
  //       value.docs.forEach((element) {
  //         Post temp = Post.fromSnapshot(element.data());
  //         postList.update((val) {
  //           posts.add(temp);
  //         });
  //       });
  //     } else {
  //       print('등록된 게시글이 없습니다!');
  //     }
  //   });
  // }

  loadPosts() async {
    await mango_dev
        .collection('post')
        .where('ownerFriendList',
            arrayContains: userViewModelController.user.value.userID)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        // Post temp = Post.fromSnapshot(element.data());

        print('PostID');
        print(element.data()['postID']);
        // this.postList.add(Post.fromSnapshot(element.data()));
        posts.add(Post.fromSnapshot(element.data()));
        print(posts[0].postID);
        print('This is Post ||');
        // postList.update((val) {
        //   posts.add(temp);
        // });
      });
    });

    return posts;
    // update();
  }
}
