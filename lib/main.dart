import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kakao_flutter_sdk/all.dart';

import 'package:mangodevelopment/app.dart';

late var cameras;
const kGoogleApiKey = "AIzaSyA4LnvO4gdIv0-zj1vUbk3cSIkZTuX3WtE";


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
  KakaoContext.clientId = "b6d297fef62ea93f6eab9450cf52dbcd";
  KakaoContext.javascriptClientId = "fe140c483552df2bcb87dad629bf0464";
  // await getDeviceToken();
  runApp(MangoApp());
}
