import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/model/post.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

class postViewModel extends GetxController {
  FirebaseFirestore mango_dev = FirebaseFirestore.instance;
  UserViewModel userViewModelController = Get.find<UserViewModel>();

  late List<Post> posts;
  late List<Post> myPosts;

  late List<Post> searchPosts;
  late List<Post> localPost;

  postViewModel() {
    posts = [];
    myPosts = [];
    searchPosts = [];
    localPost = [];
  }

  postViewModel.init() {
    posts = [];
    myPosts = [];
    searchPosts = [];
    localPost = [];
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
        myPosts.add(Post.fromSnapshot(element.data(), snap));
      });
    });
    return myPosts;
  }

  loadLocalPosts(Position userLocation) async {
    await mango_dev.collection('post').snapshots().forEach((element) {
      element.docs.forEach((element) async {
        // print(element.data()['location'].latitude);
        // print(element.data()['location'].longitude);
        var distance = await Geolocator.distanceBetween(
            userLocation.latitude,
            userLocation.longitude,
            element.data()['location'].latitude,
            element.data()['location'].longitude);
        if (distance < 2500) {
          var snap = await FirebaseFirestore.instance
              .collection('user')
              .doc(element.get('ownerID'))
              .get();
          print('($distance): is local');
          localPost.add(Post.fromSnapshot(element.data(), snap));
        } else {
          print('($distance): too far');
        }
      });
    });
    return localPost;
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
