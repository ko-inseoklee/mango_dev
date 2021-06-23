import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './view/home.dart';
import './view/login/login.dart';

void main() async {
  runApp(GetMaterialApp(home: Landing()));
}

class Landing extends StatelessWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () {
                Get.to(LogInPage(
                  title: 'Log-In',
                ));
              },
              child: Text('Login')),
          TextButton(
              onPressed: () {
                Get.to(HomePage(
                  title: 'Home',
                ));
              },
              child: Text('Home')),
        ],
      ),
    ));
  }
}
