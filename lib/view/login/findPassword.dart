import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/login/login.dart';
import 'package:mangodevelopment/view/widget/dialog/confrirmDialog.dart';
import 'package:mangodevelopment/viewModel/authentication.dart';

import '../../color.dart';

class FindPasswordPage extends StatefulWidget {
  @override
  _FindPasswordPageState createState() => _FindPasswordPageState();
}

class _FindPasswordPageState extends State<FindPasswordPage> {
  var _auth = Get.find<Authentication>();

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("비밀번호 변경"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil().setWidth(23)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "먼저 가입된 이메일을 인증해주세요",
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: ScreenUtil().setHeight(35),
              ),
              Text(
                "이메일",
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(color: MangoDisabledColorDark),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(13),
              ),
              Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "이메일을 입력해주세요";
                          }
                          if (!RegExp(
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                              .hasMatch(val)) {
                            return '잘못된 이메일 형식입니다.';
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(10),
                    ),
                    TextButton(
                      child: Text(
                        "인증",
                        style: TextStyle(color: Colors.black),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: MangoDisabledColorLight),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _auth
                              .sendPasswordResetEmailByKorean(userEmail: _emailController.text)
                              .then((value) {
                            if (value == true) {
                              Get.dialog(ConfirmDialog(
                                  contentText: "해당 이메일로 비밀번호 재설정\n링크가 전송되었습니다",
                                  onTapOK: () => Get.off(LogInPage(title: ""))));
                            } else {
                              Get.dialog(ConfirmDialog(
                                  contentText: "가입된 이메일이 없습니다",
                                  onTapOK: () => Get.back()));
                            }
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
