import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/widget/dialog/dialog.dart';
import 'package:mangodevelopment/view/widget/setting/settingMenu.dart';
import 'package:mangodevelopment/viewModel/authentication.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

import '../../app.dart';
import '../../color.dart';

class MyPageEdit extends StatefulWidget {
  @override
  _MyPageEditState createState() => _MyPageEditState();
}

class _MyPageEditState extends State<MyPageEdit> {

  Authentication _auth = Get.find<Authentication>();
  var userViewModelController = Get.find<UserViewModel>();

  final _nameController = TextEditingController();
  final _numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 정보 수정'),
        centerTitle: true,
      ),
      backgroundColor: MangoWhite,
      body: Center(
        child: Column(
          children: [
            Container(
              height: 310 * deviceHeight / prototypeHeight,
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  //TODO: should change the case of false condition with get image from firebase storage. Should change Using Stack for modify image button.
                  Stack(
                    children: [
                      Container(
                        width: 90 * deviceWidth / prototypeWidth,
                        height: 90 * deviceWidth / prototypeWidth,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: userViewModelController
                                .user.value.profileImageReference ==
                                '-1'
                                ? AssetImage('images/default_profile.png')
                                : AssetImage('images/default_profile.png'),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 44 * deviceWidth / prototypeWidth,
                        top: 50 * deviceWidth / prototypeWidth,
                        child: ElevatedButton(
                          //TODO. onPressed => 수정
                          onPressed: () {},
                          child: Icon(Icons.camera_alt, color: Colors.white),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(flex: 1,),
                  Row(
                    children: [
                      Text('이메일'),
                      Text('${_auth.user!.email}'),
                    ],
                  ),
                  Spacer(flex: 1,),
                  TextField(
                    //maxLength: 12,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[A-z]'))
                    ],
                    controller: _nameController,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.fromLTRB(10 * deviceWidth / prototypeWidth, 0,40 * deviceWidth / prototypeWidth, 0),
                        child: Text('이름'),
                      ),
                      prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                      hintText: userViewModelController.user.value.userName,
                      errorBorder:
                      OutlineInputBorder(borderSide: BorderSide(width: 1.0)),
                      border: OutlineInputBorder(),
                      focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide(width: 1.0)),
                    ),
                  ),
                  Spacer(flex: 1,),
                  TextField(
                    //maxLength: 12,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                    ],
                    controller: _numberController,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.fromLTRB(10 * deviceWidth / prototypeWidth, 0,20 * deviceWidth / prototypeWidth, 0),
                        child: Text('전화번호'),
                      ),
                      prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                      hintText: 'Coming soon...', //TODO. after adding the function of phone number
                      errorBorder:
                      OutlineInputBorder(borderSide: BorderSide(width: 1.0)),
                      border: OutlineInputBorder(),
                      focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide(width: 1.0)),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 7 * deviceHeight / prototypeHeight,
              color: MangoBehindColor,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(7 * deviceWidth / prototypeWidth,
                    0, 7 * deviceWidth / prototypeWidth, 0),
                children: [
                  settingMenu(
                    menuName: "로그아웃",
                    onTap: () {
                      comingSoon(context);
                    },
                    trailingWidth: 10,
                    trailing: SizedBox(),
                  ),
                  settingMenu(
                    menuName: "회원탈퇴",
                    onTap: () {
                      comingSoon(context);
                    },
                    trailingWidth: 10,
                    trailing: SizedBox(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
