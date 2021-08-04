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

  Food arg = Get.arguments;

  TextEditingController _titleController = new TextEditingController();
  TextEditingController _contentController = new TextEditingController();

  late String title;
  late String content;

  Future<void> addPost(String curr_uid) async {
    var temp = Post.init();

    temp.postID = ' '; // random 생성 (uuid 사용)
    temp.subtitle = '!!!'; // from text controller
    temp.ownerID = curr_uid; // curr_uid
    temp.ownerFriendList = User.fromSnapshot(await FirebaseFirestore.instance
            .collection('user')
            .doc(curr_uid)
            .snapshots()
            .first)
        .friendList
        .obs;
  }

  @override
  Widget build(BuildContext context) {
    // _user = Get.find<UserViewModel>();
    print(arg.name);

    return Scaffold(
      appBar: MangoAppBar(
        isLeading: true,
        title: '품목 등록',
        actions: [
          TextButton(
              onPressed: () async {
                String uid = Uuid().v4();
                await FirebaseFirestore.instance
                    .collection('post')
                    .doc(uid)
                    .set({
                  'foodName': arg.name,
                  'foodNum': arg.number,
                  'ownerFriendList': FieldValue.arrayUnion([]),
                });
              },
              child: Text(
                '완료',
                style: Theme.of(context).textTheme.subtitle1,
              ))
        ],
      ),
      body: Center(
        child: ListView(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ScreenUtil().setSp(16)),
                  child: Image.asset(
                      'images/category/${categoryImg[translateToKo(arg.category)]}'),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(ScreenUtil().setSp(16)),
                  child: Column(
                    children: [
                      Text('음식 이름: ${arg.name}'),
                      Text('보유 갯수: ${arg.number.toString()}'),
                    ],
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.all(ScreenUtil().setSp(8)),
              padding: EdgeInsets.all(ScreenUtil().setSp(16)),
              child: Text('제목'),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: MangoDisabledColorLight)),
              margin: EdgeInsets.all(ScreenUtil().setSp(8)),
              padding: EdgeInsets.all(ScreenUtil().setSp(8)),
              child: TextFormField(
                controller: _titleController,
                decoration: new InputDecoration(hintText: '글 제목'),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(20),
            ),
            Container(
              margin: EdgeInsets.all(ScreenUtil().setSp(8)),
              padding: EdgeInsets.all(ScreenUtil().setSp(16)),
              child: Text('내용'),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: MangoDisabledColorLight)),
              margin: EdgeInsets.all(ScreenUtil().setSp(8)),
              padding: EdgeInsets.all(ScreenUtil().setSp(16)),
              child: TextFormField(
                controller: _contentController,
                maxLines: 10,
                decoration: new InputDecoration(hintText: '내용을 입력하세요.'),
                onChanged: (value) {
                  content = value;
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
