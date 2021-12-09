import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/login/findPassword.dart';
import 'package:mangodevelopment/view/widget/dialog/confrirmDialog.dart';
import 'package:mangodevelopment/view/widget/dialog/dialog.dart';
import 'package:mangodevelopment/view/widget/dialog/editProfileImageDialog.dart'
    as edit;
import 'package:mangodevelopment/view/widget/dialog/imageSelectCard.dart';
import 'package:mangodevelopment/viewModel/authentication.dart';
import 'package:mangodevelopment/viewModel/fileStorage.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';
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
  late RefrigeratorViewModel _refrigerator;
  FileStorage _fileStoarge = Get.put(FileStorage());

  final _nameController = TextEditingController();
  bool isChangeImage = false;

  late String _userName;
  bool _isNicknameUnique = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refrigerator = Get.find<RefrigeratorViewModel>();
    _userName = userViewModelController.user.value.userName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 정보 수정'),
        centerTitle: true,
        leading: IconButton(
          icon: Text('취소'),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: Text('저장'),
            onPressed: () async {
              //Get.snackbar('저장 중', '수정사항을 저장 중입니다.');
              if (_fileStoarge.isNetworkImage.value == false) {
                print('isNetworkImage == false');
                await _fileStoarge
                    .uploadFile(
                        userViewModelController
                            .user.value.profileImageReference,
                        'profile/${_auth.user!.uid}')
                    .then((value) async {
                  _fileStoarge.isNetworkImage = true.obs;
                  userViewModelController.profileImageReference = value;
                  userViewModelController.profileImageReference = value;
                  await userViewModelController.updateUserProfileImage(
                      _auth.user!.uid, value);
                });
              }
              if (_userName != userViewModelController.user.value.userName) {
                userViewModelController.user.value.userName = _userName;
                await userViewModelController.updateUserName(
                    _auth.user!.uid, _userName);
              }

              Get.back(
                  result:
                      userViewModelController.user.value.profileImageReference);
            },
          ),
        ],
      ),
      backgroundColor: MangoWhite,
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              height: ScreenUtil().setHeight(300),
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
                          : _fileStoarge.isNetworkImage.value == true
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    userViewModelController
                                        .user.value.profileImageReference,
                                    width: 90 * deviceWidth / prototypeWidth,
                                    height: 90 * deviceWidth / prototypeWidth,
                                    fit: BoxFit.fitHeight,
                                  ))
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
                            String temp = _nameController.text;

                            var image = await Get.dialog(AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              title: Container(
                                  width: deviceWidth,
                                  child: Center(child: Text('프로필 사진 수정'))),
                              content: Container(
                                height: 150 * (deviceWidth / prototypeWidth),
                                child: edit.editProfileImageDialog(
                                  onTapCamera: () {},
                                  onTapGallery: () async {
                                    await getGalleryImage().then((value) {
                                      print("async value == $value");
                                      userViewModelController.user.value
                                          .profileImageReference = value;
                                      setState(() {
                                        _fileStoarge.isNetworkImage = false.obs;
                                      });
                                      Get.back(result: value);
                                    });
                                  },
                                ),
                              ),
                            ));
                            setState(() {
                              _nameController.text = temp;
                              print("result image == $image");
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
                      SizedBox(
                          width: ScreenUtil().setWidth(102),
                          child: Text('이메일')),
                      Text(
                        '${_auth.user!.email}',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Row(
                    children: [
                      SizedBox(
                          width: ScreenUtil().setWidth(102),
                          child: Text('전화번호')),
                      Text(
                        userViewModelController.user.value.phoneNumber,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Row(
                    children: [
                      SizedBox(
                          width: ScreenUtil().setWidth(102), child: Text('이름')),
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(),
                            hintText: _userName,
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "닉네임을 입력해주세요";
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(10),
                      ),
                      ConstrainedBox(
                          constraints: BoxConstraints.tightFor(
                              width: 90, height: ScreenUtil().setHeight(50)),
                          child: ElevatedButton(
                              child: Text('중복체크'),
                              onPressed: () async {
                                if (_nameController.text != "") {
                                  UserViewModel()
                                      .checNickNameDuplicate(
                                          _nameController.text)
                                      .then((value) {
                                    if (value == true) {
                                      //중복값이 있는 경우
                                      Get.dialog(ConfirmDialog(
                                          contentText: "이미 사용되고 있는 닉네임입니다",
                                          onTapOK: () {
                                            Get.back();
                                            _nameController.text = "";
                                          }));
                                    } else {
                                      // 중복값이 없는 경우
                                      Get.dialog(ConfirmDialog(
                                          contentText: "사용 가능한 닉네임입니다",
                                          onTapOK: () {
                                            Get.back();
                                            setState(() {
                                              _userName = _nameController.text;
                                            });
                                          }));
                                    }
                                  });
                                }
                              }))
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: ScreenUtil().setHeight(7),
              color: MangoBehindColor,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(20),
              child: InkWell(
                child: Text("비밀번호 변경"),
                onTap: () {
                  Get.dialog(mangoDialog(
                      dialogTitle: "비밀번호 변경",
                      contentText: "정말로 비밀번호 변경을 하시겠습니까?",
                      onTapOK: () {
                        Get.back();
                        _auth
                            .sendPasswordResetEmailByKorean(userEmail: _auth.user!.email.toString())
                            .then((value) {
                          if (value == true) {
                            Get.dialog(ConfirmDialog(
                                contentText: "해당 이메일로 비밀번호 재설정\n링크가 전송되었습니다",
                                onTapOK: () => Get.back()));
                          } else {
                            Get.dialog(ConfirmDialog(
                                contentText: "가입된 이메일이 없습니다",
                                onTapOK: () => Get.back()));
                          }
                        });
                      },
                      hasOK: true));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
