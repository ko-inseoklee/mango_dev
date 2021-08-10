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
    print('start');

    await mango_dev
        .collection('post')
        .where('ownerFriendList',
            arrayContains: userViewModelController.user.value.userID)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        var owner ;

        // Post temp = Post.fromSnapshot(element.data());
        await mango_dev
            .collection('user')
            .where('userID', isEqualTo: element.data()['ownerID'])
            .get()
            .then((value) {
          owner = value.docs.first;
          print('owner: ${value.docs.first.get('profileImageReference')}');
        });

        posts.add(Post.fromSnapshot(element.data(), owner));

        // postList.update((val) {
        //   posts.add(temp);
        // });
      });
      print('end');
    });

    return posts;
    // update();
  }
}
