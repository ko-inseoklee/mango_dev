import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/color.dart';
import 'package:mangodevelopment/view/login/login.dart';
import 'package:mangodevelopment/view/myAccount/myPageEdit.dart';
import 'package:mangodevelopment/view/settings/alarmSettings.dart';
import 'package:mangodevelopment/view/widget/dialog/dialog.dart';
import 'package:mangodevelopment/view/widget/setting/settingMenu.dart';
import 'package:mangodevelopment/viewModel/authentication.dart';
import 'package:mangodevelopment/viewModel/fileStorage.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';
import 'dart:io';

import '../../app.dart';

class MyPage extends StatefulWidget {
  final String title;

  const MyPage({Key? key, required this.title}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Authentication _auth = Get.find<Authentication>();
  FileStorage _fileStoarge = Get.put(FileStorage());
  late RefrigeratorViewModel _refrigerator;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserViewModel>(builder: (userViewModelController) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        backgroundColor: MangoWhite,
        body: Center(
          child: Column(
            children: [
              Container(
                height: ScreenUtil().setHeight(150),
                child: Row(
                  children: [
                    //TODO: should change the case of false condition with get image from firebase storage. Should change Using Stack for modify image button.
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          35 * deviceWidth / prototypeWidth,
                          5 * deviceWidth / prototypeWidth,
                          0,
                          5 * deviceWidth / prototypeWidth),
                      child: userViewModelController
                                  .user.value.profileImageReference ==
                              '-1'
                          ? Container(
                              width: ScreenUtil().setWidth(90),
                              height: ScreenUtil().setWidth(90),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image:
                                      AssetImage('images/default_profile.png'),
                                ),
                              ),
                            )
                          : _fileStoarge.isNetworkImage.value == true
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    userViewModelController
                                        .user.value.profileImageReference,
                                    width: ScreenUtil().setWidth(90),
                                    height: ScreenUtil().setWidth(90),
                                    fit: BoxFit.fitHeight,
                                  ))
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.file(
                                    File(userViewModelController
                                        .user.value.profileImageReference),
                                    width: ScreenUtil().setWidth(90),
                                    height: ScreenUtil().setWidth(90),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                    ),
                    SizedBox(width: ScreenUtil().setWidth(16.0),),
                    Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              userViewModelController.user.value.userName,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Text('${_auth.user!.email}'),
                            Text(userViewModelController
                                .user.value.phoneNumber),
                            SizedBox(height: ScreenUtil().setHeight(20),),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          Get.to(MyPageEdit());
                        },
                        icon: Icon(Icons.arrow_forward_ios_sharp))
                  ],
                ),
              ),
              Container(
                height: ScreenUtil().setHeight(7),
                color: MangoBehindColor,
              ),
              Container(
                  child: ListTile(
                    leading: Icon(Icons.add_alert),
                    title: Text("알림 관리",),//TODO. Font Change
                    onTap: (){
                      Get.to(SettingAlarmPage(title: "알람 관리"));
                    },
                  )
              ),
              Container(
                height: ScreenUtil().setHeight(7),
                color: MangoBehindColor,
              ),
              Container(
                  child: ListTile(
                    leading: Icon(Icons.list_alt),
                    title: Text("나의 거래 내역",),//TODO. Font Change
                    onTap: (){},
                  )
              ),
              Container(
                height: ScreenUtil().setHeight(7),
                color: MangoBehindColor,
              ),
              Expanded(
                child: ListView(
                  children: [
                    settingMenu(
                      menuName: "로그아웃",
                      onTap: () async {
                        Get.dialog(mangoDialog(
                          hasOK: true,
                          dialogTitle: '로그아웃',
                          onTapOK: () async {
                            await _auth.logOut();
                            await Get.offAll(LogInPage(title: ''));
                          },
                          contentText: '정말로 로그아웃 하시겠습니까?',
                        ));
                      },
                      trailingWidth: 10,
                      trailing: SizedBox(),
                      isActive: true,
                    ),
                    settingMenu(
                      menuName: "회원탈퇴",
                      onTap: () async {
                        Get.dialog(mangoDialog(
                            dialogTitle: '회원탈퇴',
                            contentText: '정말로 회원탈퇴 하시겠습니까?',
                            onTapOK: () async {
                              await _auth.signOut(
                                  uid: userViewModelController.userID,
                                  rID: _refrigerator.ref.value.rID);
                              await Get.offAll(LogInPage(title: ''));
                            },
                            hasOK: true));
                      },
                      trailingWidth: 10,
                      trailing: SizedBox(),
                      isActive: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
