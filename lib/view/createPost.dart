import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/color.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/model/post.dart';
import 'package:mangodevelopment/model/user.dart';
import 'package:mangodevelopment/view/widget/appBar.dart';
import 'package:mangodevelopment/widgetController/categoryController.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';
import 'package:uuid/uuid.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  // Food food = Get.arguments;
  Food food = Food.init();

  Future<void> createPost(String curr_uid) async {
    var temp = Post.init();

    //실제 값 생성 및 할당
    temp.postID = Uuid().v4().toString(); // random 생성 (uuid)
    temp.subtitle = '!!!'; // from text controller
    temp.owner = User.fromSnapshot(await FirebaseFirestore.instance
        .collection('user')
        .doc(curr_uid)
        .snapshots()
        .first);
    temp.ownerFriendList = User.fromSnapshot(await FirebaseFirestore.instance
            .collection('user')
            .doc(curr_uid)
            .snapshots()
            .first)
        .friendList
        .obs;

    temp.foods = food;
    ////

    FirebaseFirestore.instance.collection('post').doc(temp.postID).set({
      'foodName': temp.foods.name,
      'foodNum': temp.foods.number,
      'ownerFriendList': temp.ownerFriendList,
      'subtitle': temp.subtitle,
      'postID': temp.postID,
      'registTime': temp.registTime,
      'shelfLife': temp.foods.shelfLife,
      'state': temp.state,
    });

    print(
        'postID: ${temp.postID}/ subtitle: ${temp.subtitle} / ownerID: ${temp.owner.userID} / ownerFriendList: ${temp.ownerFriendList}');
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel user = Get.find<UserViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text('게시글 등록')),
      body: Center(
        child: InkWell(
          child: Text('click'),
          onTap: () {
            createPost(user.userID);
          },
        ),
      ),
    );
  }
}
