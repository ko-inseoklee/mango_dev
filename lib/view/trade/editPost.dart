import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/model/post.dart';
import 'package:mangodevelopment/view/widget/appBar.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';
import 'package:mangodevelopment/widgetController/categoryController.dart';
import 'package:uuid/uuid.dart';

import '../../color.dart';

class EditPost extends StatelessWidget {
  final String title;
  final Food food;
  final formKey = GlobalKey<FormState>();

  String contentValue = '';

  EditPost({Key? key, required this.title, required this.food})
      : super(key: key);

  UserViewModel _userViewModel = Get.find<UserViewModel>();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MangoWhite,
      appBar: MangoAppBar(
        title: title,
        isLeading: true,
      ),
      body: Column(
        children: [
          foodTile(),
          editContent(),
          Spacer(),
          Container(
            alignment: Alignment.center,
            height: ScreenUtil().setHeight(50),
            margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(16.0)),
            decoration: BoxDecoration(
                color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10.0)),
            child: TextButton(
              onPressed: () {

                // formKey.currentState!.validate();
              },
              child: Text(
                '게시글 삭제',
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  color: Colors.red
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: ScreenUtil().setHeight(50),
            margin: EdgeInsets.all(ScreenUtil().setSp(16.0)),
            decoration: BoxDecoration(
                color: Orange400, borderRadius: BorderRadius.circular(10.0)),
            child: TextButton(
              onPressed: () {
                // formKey.currentState!.validate();
              },
              child: Text(
                '저장',
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget foodTile() {
    return Container(
      alignment: Alignment.center,
      height: ScreenUtil().setHeight(86),
      margin: EdgeInsets.all(ScreenUtil().setSp(16.0)),
      decoration: BoxDecoration(
          color: MangoBehindColor, borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(10), 0, ScreenUtil().setWidth(10), 0),
            child: Image.asset(
              'images/category/${categoryImg[translateToKo(food.category)]}',
              scale: 1,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(10), 0, ScreenUtil().setWidth(10), 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.name,
                ),
                food.displayType
                    ? Text(
                        '${food.shelfLife.difference(DateTime.now()).inDays}일 전',
                        style: TextStyle(color: Red500, fontSize: 12.0))
                    : Text(
                        '${DateFormat.yMd().format(food.registrationDay)}일 등록',
                        style: TextStyle(
                            color: Purple500,
                            fontSize: ScreenUtil().setSp(12))),
              ],
            ),
          ),
          Spacer(),
          Container(
              margin: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(10), 0, ScreenUtil().setWidth(10), 0),
              child: Text(food.number.toString()))
        ],
      ),
    );
  }

  Widget editContent() {
    return Container(
        alignment: Alignment.center,
        height: ScreenUtil().setHeight(64),
        margin: EdgeInsets.all(ScreenUtil().setSp(16.0)),
        padding: EdgeInsets.only(left: ScreenUtil().setSp(8.0)),
        decoration: BoxDecoration(
            color: MangoBehindColor, borderRadius: BorderRadius.circular(10.0)),
        child: Form(
          key: formKey,
          child: TextFormField(
            maxLength: 20,
            validator: (value) {
              if (value!.isEmpty) {
                Get.snackbar('등록 오류', '메세지가 입력되지 않았습니다.');
              } else {
                contentValue = value;

                Post _post = Post.init();
                _post.postID = Uuid().v4();
                _post.state = 0;
                _post.registTime = Timestamp.now();
                _post.subtitle = contentValue;
                _post.foods = food;
                _post.owner = _userViewModel.user.value; //location 포함
                _post.chatList = [];
                _userViewModel.addPost(_post).then((_) {
                  Get.back();
                });
              }
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '남기고 싶은 메세지를 작성해주세요.(최대 20자)'),
          ),
        ));
  }

  // Widget delteContent(){
  //
  // }
}
