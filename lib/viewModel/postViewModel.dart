import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/model/post.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

class postViewModel extends GetxController {
  FirebaseFirestore mango_dev = FirebaseFirestore.instance;
  UserViewModel userViewModelController = Get.find<UserViewModel>();

  var localPost = [].obs;
  var myPost = [].obs;
  var count = 0.obs;

  loadMyPosts() async {
    // count = 0 as RxInt;
    clearMyPost();
    mango_dev
        .collection('post')
        .where('ownerID', isEqualTo: userViewModelController.user.value.userID)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        var snap = await FirebaseFirestore.instance
            .collection('user')
            .doc(element.get('ownerID'))
            .get();

        Post _post = Post.fromSnapshot(element.data(), snap);
        var _snap = await FirebaseFirestore.instance
            .collection('myFood')
            .doc(_post.foods.fId)
            .get()
            .then((value) => value.data());
        _post.foods = Food.fromSnapshot(_snap!);

        myPost.add(_post);
        mango_dev.collection('post').doc(element.id).update({
          'ownerName': _post.owner.userName,
          'ownerID': _post.owner.userID,
          'profileImageReference': _post.owner.profileImageReference,
        });
      });
    });
    // localPost.value = localPost;
    update();
    refresh();
  }

  Future clearPost() async {
    return localPost.clear();
  }

  Future clearMyPost() async{
    return myPost.clear();
}

  Future<void> loadLocalPosts(GeoPoint userLocation) async {
    // count = 0 as RxInt;
    clearPost();
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
          // print("ELEMET: ${element.get('ownerID')}");
          var snap = await FirebaseFirestore.instance
              .collection('user')
              .doc(element.get('ownerID'))
              .get();

          Post _post = Post.fromSnapshot(element.data(), snap);
          var _snap = await FirebaseFirestore.instance
              .collection('myFood')
              .doc(_post.foods.fId)
              .get()
              .then((value) => value.data());
          _post.foods = Food.fromSnapshot(_snap!);

          localPost.add(_post);
          count++;
          mango_dev.collection('post').doc(element.id).update({
            'ownerName': _post.owner.userName,
            'ownerID': _post.owner.userID,
            'profileImageReference': _post.owner.profileImageReference,
          });
        }
      });
    });
    // localPost.value = localPost;
    update();
    refresh();
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
