import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/app.dart';
import 'package:mangodevelopment/color.dart';
import 'package:mangodevelopment/view/login/findPassword.dart';
import 'package:mangodevelopment/view/login/signUp.dart';
import 'package:mangodevelopment/view/widget/dialog/confrirmDialog.dart';
import 'package:mangodevelopment/viewModel/authentication.dart';

import '../../landing.dart';

class LogInPage extends StatefulWidget {
  final title;

  LogInPage({Key? key, required this.title}) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  var authController = Get.find<Authentication>();

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<Authentication>(
        init: Authentication(),
        builder: (_) {
          return Scaffold(
            backgroundColor: Theme.of(context).accentColor,
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: ScreenUtil().setHeight(150),
                    ),
                    Text(
                      '당신의 냉장고를 관리해주는 집요정,',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(color: MangoWhite),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(18),
                    ),
                    Image.asset(
                      'images/login/appName.png',
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(16),
                    ),
                    Text(
                      'Manager + 古',
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(color: MangoWhite),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(13),
                    ),
                    Image.asset(
                      'images/login/logo.png',
                      width: ScreenUtil().setWidth(70),
                      height: ScreenUtil().setHeight(114),
                      fit: BoxFit.contain,
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(40),
                    ),
                    loginMethodWidget(platform, context),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget loginMethodWidget(bool isIOS, context) {
    var loginWidth = 275.0;

    return Container(
      alignment: Alignment.center,
      width: ScreenUtil().setWidth(loginWidth),
      height: ScreenUtil().setHeight(600),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: MangoWhite),
              decoration: const InputDecoration(
                labelText: '이메일',
                labelStyle: TextStyle(color: MangoWhite, fontSize: 15),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: MangoWhite),
                ),
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
            TextFormField(
              controller: _passwordController,
              style: TextStyle(color: MangoWhite),
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '비밀번호',
                labelStyle: TextStyle(color: MangoWhite, fontSize: 15),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: MangoWhite),
                ),
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return "비밀번호를 입력해주세요";
                }
              },
            ),
            SizedBox(
              height: ScreenUtil().setHeight(40),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: double.infinity,
                  minHeight: ScreenUtil().setHeight(46)),
              child: TextButton(
                child: Text(
                  '로그인',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: Orange700),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    //all validation pass
                    Get.find<Authentication>()
                        .emailLogin(
                        email: _emailController.text,
                        password: _passwordController.text)
                        .then((value) async {
                      if (value == "success") {
                        print("success");
                        await authController.loadId();
                        Get.off(Landing());
                      }
                      else if(value == "fail"){
                        print("이메일 주소 또는 비밀번호가 틀렸습니다.");
                        Get.dialog(ConfirmDialog(
                            contentText: "이메일 주소 또는 비밀번호가 틀렸습니다",
                            onTapOK: () {
                              Get.back();
                            }));
                      }
                      else if(value == "emailFail"){
                        Get.dialog(ConfirmDialog(
                            contentText: "유효하지 않은 이메일입니다\n이메일을 확인하여 인증을 완료해주세요",
                            onTapOK: () {
                              Get.back();
                            }));
                      }
                    });
                  }
                },
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(30),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "비밀번호를 잊으셨나요? ",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: MangoWhite),
                ),
                InkWell(
                  child: Text(
                    "비밀번호 찾기",
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: MangoWhite,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: () {
                    Get.to(FindPasswordPage());
                  },
                )
              ],
            ),
            SizedBox(
              height: ScreenUtil().setHeight(5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "망고가 처음이신가요? ",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: MangoWhite),
                ),
                InkWell(
                  child: Text(
                    "회원가입",
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: MangoWhite,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: () {
                    Get.to(SignUpPage());
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
