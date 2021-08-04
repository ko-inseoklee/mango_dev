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
  // late UserViewModel _user;

  // Food arg = Get.arguments;

  TextEditingController _titleController = new TextEditingController();
  TextEditingController _contentController = new TextEditingController();

  late String title;
  late String content;

  Future<void> createPost(String curr_uid) async {
    var temp = Post.init();

    temp.postID = ' '; // random 생성 (uuid)
    temp.subtitle = '!!!'; // from text controller
    temp.ownerID = curr_uid; // curr_uid
    temp.ownerFriendList = User.fromSnapshot(await FirebaseFirestore.instance
            .collection('user')
            .doc(curr_uid)
            .snapshots()
            .first)
        .friendList
        .obs;

    print(
        'postID: ${temp.postID}/ subtitle: ${temp.subtitle} / ownerID: ${temp.ownerID} / ownerFriendList: ${temp.ownerFriendList}');
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
