import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:get/get.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/all.dart' as kakao;
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class Authentication extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int authWay = 0; //0==google, 1==kakao
  User? user;

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  late Future<String> id;

  Authentication() {
    _auth.authStateChanges().listen((newUser) {
      print('Authentication - FirebaseAuth - AuthStateChanged - $newUser');
      user = newUser;
      update();
    }, onError: (e) {
      print('Authentication - FirebaseAuth - AuthStateChanged - $e');
    });
  }

  Future<String> loadId() async {
    final SharedPreferences prefss = await prefs;
    final String id = (prefss.getString('id') ?? user!.uid);
    print("id = $id");

    return prefss.setString('id', id).then((value) {
      return id;
    });
  }

  Future<void> googleLogin() async {
    try {
      UserCredential userCredential;
      if (kIsWeb) {
        GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleAuthProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        final GoogleSignInAuthentication googleAuth =
            await googleUser!.authentication;

        final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

        final authResult = await _auth.signInWithCredential(credential);

        user = authResult.user!;
        authWay = 0;
        update();
      }
    } catch (e) {
      print('Error reported: $e');
    }
    update();
  }


  _issueAccessToken(String authCode) async {
    try {
      // print("accessToken");
      var token = await kakao.AuthApi.instance.issueAccessToken(authCode);
      print('token == ${token}');
      await kakao.AccessTokenStore.instance.toStore(token);

      final authResult =
      await _auth.signInWithCustomToken(token.tokenType);
      // print(authResult);
      // String resultToken = await kakao.AccessTokenStore.instance.fromStore().toString();
      // FirebaseAuth.instance.signInWithCustomToken(resultToken);
      // print(token);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> kakaoLogin() async {

    final installed = await kakao.isKakaoTalkInstalled();
    // print('kako installed: ' + installed.toString());
    bool _isKakaoInstalled = installed;
    if(_isKakaoInstalled == true){
      try {
        var code = await kakao.AuthCodeClient.instance.requestWithTalk();
        await _issueAccessToken(code);
      } catch (e) {
        print(e.toString());
      }
    }
    else{
      try {
        var code = await kakao.AuthCodeClient.instance.request();
        await _issueAccessToken(code);
    final authResult =
        await _auth.signInWithCustomToken(code);
    // return authResult.user;
    user = authResult.user!;

      } catch (e) {
        print("error");
        print(e.toString());
      }
    }
    final user2 = await kakao.UserApi.instance.me();
    user = user2.kakaoAccount as User?;
    authWay = 1;
    update();
  }

  Future<void> logOut() async {
    try {
      if(authWay == 1){ //kakao login
        await kakao.UserApi.instance.logout();
      }
      _auth.signOut();
      prefs.then((SharedPreferences pref) => pref.remove('id'));
      update();
    } catch (e) {
      print('exception error: $e');
    }
  }

  Future<void> signOut({required String uid, required String rID}) async {
    try {
      await RefrigeratorViewModel().deleteRefrigerator(rID: rID);
      await UserViewModel().deleteUser(uid);

      if(authWay == 1){ //kakao login
        await kakao.UserApi.instance.logout();
      }

      _auth.signOut();
      prefs.then((SharedPreferences pref) => pref.remove('id'));
      update();
    } catch (e) {
      print('exception error: $e');
    }
  }

  Future<bool> hasData(String uid) async {
    bool result = false;

    await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .get()
        .then((value) => result = value.exists);

    return result;
  }

  Future<void> deleteAll(String uid) async {
    await UserViewModel().deleteUser(uid);
  }
}
