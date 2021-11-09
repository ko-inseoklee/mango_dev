import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/model/post.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

class postViewModel extends GetxController {
  FirebaseFirestore mango_dev = FirebaseFirestore.instance;
  UserViewModel userViewModelController = Get.find<UserViewModel>();

  // late List<Post> myPosts;
  //
  // late List<Post> searchPosts;
  // RxList<Post> localPost = [Post.init()].obs;

  List localPost = <Post>[].obs;
  int count = 0;

  // loadMyPosts() async {
  //   var snap = await FirebaseFirestore.instance
  //       .collection('user')
  //       .doc(userViewModelController.userID)
  //       .get();
  //   this.myPosts = [];
  //   await mango_dev
  //       .collection('post')
  //       .where('ownerID', isEqualTo: userViewModelController.user.value.userID)
  //       .get()
  //       .then((value) {
  //     value.docs.forEach((element) async {
  //       // myPosts.add(Post.fromSnapshot(element.data(), snap));
  //     });
  //   });
  //   return myPosts;
  // }

   Future clearPost() async {
     return localPost.clear();
   }

  Future<void>loadLocalPosts(Position userLocation) async {
    mango_dev
        .collection('post')
        .orderBy('registTime', descending: true)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
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

          Post _post = Post.fromSnapshot(element.data(), snap);
          localPost.add(_post);
          print(localPost);
          mango_dev.collection('post').doc(element.id).update({
            'ownerName': _post.owner.userName,
            'ownerID': _post.owner.userID,
            'profileImageReference': _post.owner.profileImageReference,
          });
        }
      });
    });
    update();
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
