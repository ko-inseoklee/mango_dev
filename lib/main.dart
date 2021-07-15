import 'package:camera/camera.dart';
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

late var cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //// Add this
  await Firebase.initializeApp();
  cameras = await availableCameras();

  runApp(MangoApp());
}
