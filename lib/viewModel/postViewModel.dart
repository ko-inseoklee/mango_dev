import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/model/post.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

class postViewModel extends GetxController {
  FirebaseFirestore mango_dev = FirebaseFirestore.instance;
  UserViewModel userViewModelController = Get.find<UserViewModel>();

  late List<Post> posts;
  late List<Post> myPosts;

  late List<Post> searchPosts;

  postViewModel() {
    posts = [];
    myPosts = [];
    searchPosts = [];
  }

  postViewModel.init() {
    posts = [];
    myPosts = [];
    searchPosts = [];
  }

  cleanPost() {
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
        var snap = await FirebaseFirestore.instance
            .collection('user')
            .doc(element.get('ownerID'))
            .get();
        posts.add(Post.fromSnapshot(element.data(), snap));
      });
    });
    // print('loading post.. ');
    // for (int i = 0; i < posts.length; i++) {
    //   print('${posts[i].postID}},');
    // }
    return posts;
  }

  loadMyPosts() async {
    var snap = await FirebaseFirestore.instance
        .collection('user')
        .doc(userViewModelController.userID)
        .get();
    this.myPosts = [];
    await mango_dev
        .collection('post')
        .where('ownerID', isEqualTo: userViewModelController.user.value.userID)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        myPosts.add(Post.fromSnapshot(element.data(),snap));
      });
    });
    // print('loading post.. ');
    // for (int i = 0; i < posts.length; i++) {
    //   print('${posts[i].postID}},');
    // }

    return myPosts;
  }

// loadSearchPosts(String _search) async {
//   this.searchPosts = [];
//   mango_dev
//       .collection('post')
//       .where('ownerID', isEqualTo: userViewModelController.user.value.userID)
//       .where('foodName', isEqualTo: _search)
//       .get()
//       .then((value) {
//     value.docs.forEach((element) async {
//       myPosts.add(Post.fromSnapshot(element.data()));
//     });
//   });
// }
}
