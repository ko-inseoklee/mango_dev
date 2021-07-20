import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mangodevelopment/app.dart';
import 'package:mangodevelopment/view/login/addUserInfo.dart';
import 'package:mangodevelopment/view/splash.dart';
import './view/home.dart';
import './view/login/login.dart';
import 'color.dart';

late var cameras;

Future<void> saveTokenToDatabase(String token) async {
  String userId = await FirebaseAuth.instance.currentUser!.uid.toString();
  print('userID = ' + userId);

  await FirebaseFirestore.instance.collection('user').doc(userId).update({
    'tokens': FieldValue.arrayUnion([token]),
  });
}

Future<void> getDeviceToken() async {
  //save device token
  String? token = await FirebaseMessaging.instance.getToken();
  await saveTokenToDatabase(token!);
  FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //// Add this
  await Firebase.initializeApp();
  cameras = await availableCameras();
  // await getDeviceToken();
  runApp(MangoApp());
}
