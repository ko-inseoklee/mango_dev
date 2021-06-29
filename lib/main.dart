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

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Add this
  
  runApp(MangoApp());
}
