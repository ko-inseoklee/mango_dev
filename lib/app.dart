import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/home.dart';
import 'package:mangodevelopment/view/login/login.dart';
import 'package:mangodevelopment/view/login/telTest.dart';

import 'color.dart';
import 'landing.dart';
import 'view/trade/friend/friendList.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

var deviceWidth = 411.0;
var deviceHeight = 820.0;
var prototypeWidth = 375.0;
var prototypeHeight = 812.0;

var platform = true;

Future<void> saveTokenToDatabase(String token) async {
  String userId = await FirebaseAuth.instance.currentUser!.uid.toString();

  await FirebaseFirestore.instance.collection('user').doc(userId).update({
    'tokens': token,
  });
}

Future<void> getDeviceToken() async {
  //save device token
  String? token = await FirebaseMessaging.instance.getToken();

  await saveTokenToDatabase(token!);
  FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
}

class MangoApp extends StatefulWidget {
  const MangoApp({Key? key}) : super(key: key);

  @override
  _MangoAppState createState() => _MangoAppState();
}

class _MangoAppState extends State<MangoApp> {
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getInitialMessage();

    getDeviceToken();

    //give message of notification on which user taps
    //open app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print(message.notification!.body);
        print(message.notification!.title);

        // final route2 = message.data['route'];
        // Get.to(route2);
      }
    });

    // //opened in foreground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        Get.snackbar(message.notification!.title as String,
            message.notification!.body as String);
        // flutterLocalNoification
        print(message.notification!.body);
        print(message.notification!.title);
      }
    });

    // //opened in background
    // //when user taps on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification != null) {
        print(message.notification!.body);
        print(message.notification!.title);
        //print route from message
        // final route = message.data['route'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () => GetMaterialApp(
        // home: Landing(),
         home: TelTestPage(),
        // home: LogInPage(title: '로그인 페이지',),
        theme: _mangoTheme,
        getPages: [GetPage(name: 'FriendList', page: () => FriendListPage())],
      ),
      designSize: Size(375, 812),
    );
  }
}

final ThemeData _mangoTheme = _buildMangoTheme();

ThemeData _buildMangoTheme() {
  final ThemeData base = ThemeData.light();

  return base.copyWith(
    accentColor: Orange400,
    primaryColor: MangoWhite,
    unselectedWidgetColor: MangoDisabledColor,
    focusColor: Orange200,
    hoverColor: Orange400,
    errorColor: MangoErrorColor,
    cursorColor: Orange400,
    buttonTheme: base.buttonTheme.copyWith(
        buttonColor: MangoDisabledColor,
        colorScheme: base.colorScheme.copyWith(secondary: Orange400)),
    colorScheme: ColorScheme.light().copyWith(primary: Orange500),
    textTheme: _buildMangoTextTheme(base.textTheme),
    primaryTextTheme: _buildMangoTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildMangoTextTheme(base.accentTextTheme),
    iconTheme: base.iconTheme.copyWith(color: MangoBlack),
    primaryIconTheme: base.iconTheme.copyWith(color: MangoBlack),
  );
}

TextTheme _buildMangoTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline1: base.headline1!.copyWith(
          fontSize: 96.0,
          fontWeight: FontWeight.w300,
        ),
        headline2: base.headline2!.copyWith(
          fontSize: 60.0,
          fontWeight: FontWeight.w300,
        ),
        headline3: base.headline3!.copyWith(
          fontSize: 40.0,
          fontWeight: FontWeight.w400,
        ),
        /* headline4: dialog title*/
        headline4: base.headline4!.copyWith(
          fontSize: 34.0,
          fontWeight: FontWeight.w400,
        ),
        /* headline5: hintText of ProfilePage(subtitle 2_KR)*/
        headline5: base.headline5!.copyWith(
          fontSize: 24.0,
          fontWeight: FontWeight.w500,
        ),
        /* headline6: Text of AppBar */
        headline6: base.headline6!.copyWith(
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
        ),
        subtitle1: base.subtitle1!.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
        /* subtitle2: substitle of ListTile*/
        subtitle2: base.subtitle2!.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        ),
        bodyText1: base.bodyText1!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
        ),
        /* bodyText2: dialog text */
        bodyText2: base.button!.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
        /* button: all of button + tabs */
        button: base.button!.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
        caption: base.caption!.copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
        ),
        overline: base.caption!.copyWith(
          fontSize: 10.0,
          fontWeight: FontWeight.w500,
        ),
      )
      .apply(
          fontFamily: 'NotoSansKR',
          bodyColor: Colors.black,
          displayColor: Colors.black);
}
