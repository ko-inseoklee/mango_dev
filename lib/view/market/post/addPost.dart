import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mangodevelopment/color.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/model/post.dart';
import 'package:mangodevelopment/view/widget/appBar.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';
import 'package:mangodevelopment/widgetController/categoryController.dart';
import 'package:uuid/uuid.dart';

class AddPostPage extends StatelessWidget {
  final String title;
  final Food food;
  final formKey = GlobalKey<FormState>();

  AddPostPage({Key? key, required this.title, required this.food})
      : super(key: key);

  UserViewModel _userViewModel = Get.find<UserViewModel>();

  String contentValue = '';

  @override
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
          addContent(),
          Spacer(),
          Container(
            alignment: Alignment.center,
            height: ScreenUtil().setHeight(45),
            margin: EdgeInsets.all(ScreenUtil().setSp(16.0)),
            decoration: BoxDecoration(
                color: Orange400, borderRadius: BorderRadius.circular(10.0)),
            child: TextButton(
              onPressed: () {
                formKey.currentState!.validate();
              },
              child: Text(
                '등록',
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget addContent() {
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

                // TODO: This is for post class
                // Post _post = new Post(
                //   postID: Uuid().v4(),
                //   state: 0,
                //   registTime: DateTime.now(),
                //   subtitle: contentValue,
                //   foods: food,
                //   owner: _userViewModel.user.value
                // );
                // TODO: Should be add post in the userViewModel
                // _userViewModel.addPost(post: _post).then((){Get.to()});
              }
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '남기고 싶은 메세지를 작성해주세요.(최대 20자)'),
          ),
        ));
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
}
