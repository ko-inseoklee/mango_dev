import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mangodevelopment/app.dart';
import 'package:mangodevelopment/view/login/addUserInfo.dart';
import 'package:mangodevelopment/view/splash.dart';
import './view/home.dart';
import './view/login/login.dart';
import 'color.dart';

// import 'package:firebase_messaging/firebase_messaging.dart';
//
// FirebaseMessaging messaging = FirebaseMessaging.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Add this
  await Firebase.initializeApp();
  runApp(MangoApp());

  //
  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   print('Got a message whilst in the foreground!');
  //   print('Message data: ${message.data}');
  //
  //   if (message.notification != null) {
  //     print(message.notification!.body);
  //     print('Message also contained a notification: ${message.notification}');
  //   }
  // });
}
