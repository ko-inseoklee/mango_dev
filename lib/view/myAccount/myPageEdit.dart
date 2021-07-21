import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/login/login.dart';
import 'package:mangodevelopment/view/widget/dialog/dialog.dart';
import 'package:mangodevelopment/view/widget/dialog/imageSelectCard.dart';
import 'package:mangodevelopment/view/widget/setting/settingMenu.dart';
import 'package:mangodevelopment/viewModel/authentication.dart';
import 'package:mangodevelopment/viewModel/fileStorage.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';
import 'dart:io';

import '../../app.dart';
import '../../color.dart';

class MyPageEdit extends StatefulWidget {
  @override
  _MyPageEditState createState() => _MyPageEditState();
}

class _MyPageEditState extends State<MyPageEdit> {
  Authentication _auth = Get.find<Authentication>();
  var userViewModelController = Get.find<UserViewModel>();
  FileStorage _fileStoarge = Get.put(FileStorage());

  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  bool isChangeImage = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('내 정보 수정'),
        centerTitle: true,
        leading: IconButton(
          icon: Text('취소'),
          onPressed: () {
            setState(() {
              _fileStoarge.isNetworkImage = false.obs;
            });
            Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: Text('저장'),
            onPressed: () async {
              // _nameController.text != '' ?
              // userViewModelController.user.value.userName =
              //     _nameController.text
              //     : null;
              _nameController.text != ''?
                  await userViewModelController.setUserName(_nameController.text)
              : null;

               _fileStoarge.isNetworkImage.value == true ?
                await _fileStoarge
                    .uploadFile(
                    userViewModelController.user.value.profileImageReference,
                    'profile/${_auth.user!.uid}')
                    .then((value) {
                      _fileStoarge.isNetworkImage = false.obs;
                }) : null;
              await userViewModelController.updateUserInfo(_auth.user!.uid).then((value){
                Get.back(result: userViewModelController.user.value.profileImageReference);
              });
            },
          ),
        ],
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
                      userViewModelController
                                  .user.value.profileImageReference ==
                              '-1'
                          ? Container(
                              width: 90 * deviceWidth / prototypeWidth,
                              height: 90 * deviceWidth / prototypeWidth,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image:
                                      AssetImage('images/default_profile.png'),
                                ),
                              ),
                            )
                          // : _fileStoarge.isNetworkImage.value == true
                          //     ? ClipRRect(
                          //         borderRadius: BorderRadius.circular(50),
                          //         child: Image.network(
                          //           userViewModelController
                          //               .user.value.profileImageReference,
                          //           width: 90 * deviceWidth / prototypeWidth,
                          //           height: 90 * deviceWidth / prototypeWidth,
                          //           fit: BoxFit.fitHeight,
                          //         ))
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.file(
                                    File(userViewModelController
                                        .user.value.profileImageReference),
                                    width: 90 * deviceWidth / prototypeWidth,
                                    height: 90 * deviceWidth / prototypeWidth,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                      Positioned(
                        left: 44 * deviceWidth / prototypeWidth,
                        top: 50 * deviceWidth / prototypeWidth,
                        child: ElevatedButton(
                          onPressed: () async {
                            var image = await Get.dialog(AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              title: Container(
                                  width: deviceWidth,
                                  child: Center(child: Text('프로필 사진 수정'))),
                              content: Container(
                                height: 150 * (deviceWidth / prototypeWidth),
                                child: imageSelectCard(
                                  onTapCamera: () {},
                                  onTapGallery: () async {
                                    await getGalleryImage().then((value) {
                                      userViewModelController.user.value
                                          .profileImageReference = value;
                                      setState(() {
                                        _fileStoarge.isNetworkImage = true.obs;
                                      });
                                      Get.back(result: value);
                                    });
                                  },
                                ),
                              ),
                            ));
                            setState(() {
                              userViewModelController
                                  .user.value.profileImageReference = image;
                            });
                          },
                          child: Icon(Icons.camera_alt, color: Colors.white),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Row(
                    children: [
                      Text('이메일    '),
                      Text('${_auth.user!.email}'),
                    ],
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  TextField(
                    //maxLength: 12,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[A-z]'))
                    ],
                    controller: _nameController,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.fromLTRB(
                            10 * deviceWidth / prototypeWidth,
                            0,
                            40 * deviceWidth / prototypeWidth,
                            0),
                        child: Text('이름'),
                      ),
                      prefixIconConstraints:
                          BoxConstraints(minWidth: 0, minHeight: 0),
                      hintText: userViewModelController.user.value.userName,
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0)),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0)),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  TextField(
                    //maxLength: 12,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                    ],
                    controller: _numberController,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.fromLTRB(
                            10 * deviceWidth / prototypeWidth,
                            0,
                            20 * deviceWidth / prototypeWidth,
                            0),
                        child: Text('전화번호'),
                      ),
                      prefixIconConstraints:
                          BoxConstraints(minWidth: 0, minHeight: 0),
                      hintText: 'Coming soon...',
                      //TODO. after adding the function of phone number
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0)),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0)),
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
                  ),
                  settingMenu(
                    menuName: "회원탈퇴",
                    onTap: () async {
                      Get.dialog(mangoDialog(
                          dialogTitle: '회원탈퇴',
                          contentText: '정말로 회원탈퇴 하시겠습니까?',
                          onTapOK: () async {
                            await _auth.signOut();
                            await Get.offAll(LogInPage(title: ''));
                          },
                          hasOK: true));
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

  // Future<void> _loadChangeInfo() async{
  //
  //   print('isNetWork???? ${_fileStoarge.isNetworkImage.value}');
  //
  //   // ignore: unnecessary_statements
  //   _fileStoarge.isNetworkImage.value == false ?
  //   await _fileStoarge
  //       .uploadFile(
  //       userViewModelController.user.value.profileImageReference,
  //       'profile/${_auth.user!.uid}')
  //       .then((value) {
  //     userViewModelController.user.value.profileImageReference =
  //         value;
  //     setState(() {
  //       _fileStoarge.isNetworkImage = true.obs;
  //       _nameController.text != '' ?
  //       userViewModelController.user.value.userName = _nameController.text
  //           : null;
  //     });
  //   }) : _nameController.text != '' ?
  //   userViewModelController.user.value.userName = _nameController.text
  //       : null;
  // }
}
