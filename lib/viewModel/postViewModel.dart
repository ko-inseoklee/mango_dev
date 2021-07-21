// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:mangodevelopment/model/post.dart';
//
// class postViewModel extends GetxController {
//   FirebaseFirestore mango_dev = FirebaseFirestore.instance;
//
//   var post = Post.init().obs;
//
//   getPostFromFirebase({required postID}) {
//     mango_dev.collection('post').doc(postID);
//   }
//
//   getFriendList({required uid}){
//     mango_dev.collection('friendList').
//   }
//
//   findPostFromOwner({required uid}){
//     for(String uid in frindlist){
//
//     }
//     mango_dev.collection('post').where('onwerID',isEqualTo: uid).get().then((value) => value);
//
// }
// }
//
// // changeViewMode({required int viewMode}) {
// //   foods.update((val) {
// //     val!.currentTab = viewMode;
// //   });
// // }
