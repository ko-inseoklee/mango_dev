import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/login/addUserInfo.dart';
import 'package:mangodevelopment/view/login/addUserInfo2.dart';
import 'package:mangodevelopment/view/widget/mangoIndicator.dart';
import 'package:mangodevelopment/viewModel/authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'view/home.dart';
import 'view/login/login.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  Authentication authController = Get.put(Authentication());

  @override
  void initState() {
    super.initState();
    authController.id = authController.prefs.then((SharedPreferences prefs) {
      return (prefs.getString('id') ?? '');
    });
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  bool isSecondPage = false;

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    return FutureBuilder<String>(
        future: authController.id,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return MangoCircularIndicator();
            default:
              if (snapshot.data == '') {
                return LogInPage(title: 'hi');
              } else {
                return FutureBuilder(
                    future: authController.hasData(authController.user!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData == false) {
                        return MangoCircularIndicator();
                      } else if (snapshot.data == false) {
                        return AddUserInfoPage2();
                      } else {
                        //_prefs!.setString('id', authController.user!.uid);
                        return HomePage(title: 'hi');
                      }
                    });
              }
          }
        });
  }
}
