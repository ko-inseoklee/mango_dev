import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/viewModel/authentication.dart';

import '../../landing.dart';

class EmailLoginPage extends StatefulWidget {
  @override
  _EmailLoginPageState createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<EmailLoginPage> {

  final TextEditingController _emailTextController = new TextEditingController();
  final TextEditingController _passwordTextController = new TextEditingController();

  int _pageIndex = int.parse(Get.arguments);
  var authController = Get.find<Authentication>();

  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Email'),),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Column(
            children: [
              TextField(
                controller: _emailTextController,
                decoration: new InputDecoration(
                  hintText: "Email",
                  enabledBorder: UnderlineInputBorder(),
                ),
              ),
              TextField(
                controller: _passwordTextController,
                decoration: new InputDecoration(
                  hintText: "Password",
                  enabledBorder: UnderlineInputBorder(),
                ),
              ),
              TextButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      _pageIndex == 0 ? '로그인' : '회원가입',
                      style: Theme
                          .of(context)
                          .textTheme
                          .subtitle2,
                    ),
                  ],
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Theme
                      .of(context)
                      .primaryColor,
                ),
                onPressed: () {
                  // Get.find<Authentication>().googleLogin().then((value) async{
                  //   await authController.loadId();
                  //   Get.off(Landing());
                  // });
                  _pageIndex == 0 ? //로그인
                  authController.emailLogin(email: '_emailTextController.text', password: '_passwordTextController.text')
                      .then((value) async {
                    await authController.loadId();
                    Get.off(Landing());
                  }) : // 회원가입
                  authController.emailSignUp(email: '_emailTextController.text', password: '_passwordTextController.text')
                      .then((value) async {
                    await authController.loadId();
                    Get.off(Landing());
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
