import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/widget/postCardWidget.dart';
import 'package:mangodevelopment/viewModel/postViewModel.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

class MyPost extends StatefulWidget {
  @override
  _MyPostState createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  postViewModel post = Get.put(postViewModel());
  UserViewModel userViewModelController = Get.find<UserViewModel>();
  postViewModel postViewModelController = Get.find<postViewModel>();

  @override
  void initState() {
    super.initState();
    Get.find<postViewModel>().loadMyPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('나의 게시글'),
      ),
      body: Obx(() {
        return  ListView.separated(
            itemBuilder: (context, index) {
              return MangoPostCard(
                  post: postViewModelController.myPost[index]);
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
            itemCount: postViewModelController.myPost.length);
      }),
    );
  }
}
