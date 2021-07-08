import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/login/addUserInfo.dart';
import 'package:mangodevelopment/viewModel/authentication.dart';

import 'app.dart';
import 'view/home.dart';
import 'view/login/login.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  late Authentication authController;

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();


    // if (Platform.isIOS) iOS_Permission();

  bool isSecondPage = false;


  @override
  Widget build(BuildContext context) {
    authController = Get.put(Authentication());

    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;


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
            // return Center(
            //   child: TextButton(child: Text('sign out'),onPressed: () => authController.signOut().then((value) => Get.to(Landing()),))
            // );
            return AddUserInfoPage();
          } else {
            return HomePage(title: 'hi');
          }
        }) : LogInPage(
    title: 'hi',
    );

      /*This is for test else*/
      // return FutureBuilder(
      //     future: _initialization,
      //     builder: (context, snapshot) {
      //       if (snapshot.hasError) {
      //         return Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       }
      //
      //       // Once complete, show your application
      //       if (snapshot.connectionState == ConnectionState.done) {
      //         return Scaffold(
      //             body: Center(
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   TextButton(
      //                       onPressed: () {
      //                         Get.to(() => LogInPage(
      //                           title: 'Log-In',
      //                         ));
      //                       },
      //                       child: Text('Login')),
      //                   TextButton(
      //                       onPressed: () {
      //                         Get.to(() => HomePage(
      //                           title: 'Home',
      //                         ));
      //                       },
      //                       child: Text('Home')),
      //                   TextButton( // for mj TEST
      //                       onPressed: () {
      //                         Get.to(() => AddUserInfoPage());
      //                       },
      //                       child: Text('AddUserInfo')),
      //                   TextButton( // for mj TEST
      //                       onPressed: () {
      //                         Get.to(() => GuidePage());
      //                       },
      //                       child: Text('Guide')),
      //                 ],
      //               ),
      //             ));
      //       }
      //
      //       // Otherwise, show something whilst waiting for initialization to complete
      //       return Scaffold(
      //         body: Center(
      //           child: CircularProgressIndicator(),
      //         ),
      //       );
      //     });


    // }
  }
}
