import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/addUserInfo.dart';
import 'package:mangodevelopment/view/splash.dart';

import './view/home.dart';
import './view/login/login.dart';
import 'color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Add this

  runApp(GetMaterialApp(home: Landing()));
}

class Landing extends StatelessWidget {
  Landing({Key? key}) : super(key: key);

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        Get.to(() => LogInPage(
                              title: 'Log-In',
                            ));
                      },
                      child: Text('Login')),
                  TextButton(
                      onPressed: () {
                        Get.to(() => HomePage(
                              title: 'Home',
                            ));
                      },
                      child: Text('Home')),
                  TextButton(
                      onPressed: () {
                        Get.to(() => AddUserInfoPage());
                      },
                      child: Text('addInfo')),
                ],
              ),
            ));
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
