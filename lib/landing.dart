import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/color.dart';
import 'package:mangodevelopment/view/login/addUserInfo.dart';
import 'package:mangodevelopment/viewModel/authentication.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

import 'app.dart';
import 'view/home.dart';
import 'view/login/login.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  Authentication authController = Get.put(Authentication());

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();


  // if (Platform.isIOS) iOS_Permission();

  bool isSecondPage = false;


  @override
  Widget build(BuildContext context) {

    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    print('exitUSer? ${authController.exitUser.value}');

    return authController.user == null ? LogInPage(
      title: 'hi',
    ): authController.exitUser.value ? FutureBuilder(
        future: authController.hasData(authController.user!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data == false) {
            return AddUserInfoPage();
          } else {
            //userViewModelController.setUserInfo(authController.user!.uid);
            return HomePage(title: 'hi');
          }
        }) : LogInPage(
      title: 'hi',
    );

  }
}