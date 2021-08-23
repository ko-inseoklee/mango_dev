import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:get/get.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class Authentication extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
        update();
      }
    } catch (e) {
      print('Error reported: $e');
    }
    update();
  }

  Future<void> kakaoLogin() async {
    final clientState = Uuid().v4();
    final url = Uri.https('kauth.kakao.com', '/oauth/authorize', {
      'response_type': 'code',
      'client_id': 'ae58524d5e3551dcc6608530c1e38422',
      'response_mode': 'form_post',
      'redirect_uri':
          'https://woolly-nosy-titanoceratops.glitch.me/callbacks/kakao/sign_in',
      'state': clientState,
    });

    final result = await FlutterWebAuth.authenticate(
        url: url.toString(), callbackUrlScheme: "webauthcallback");

    final body = Uri.parse(result).queryParameters;

    final tokenUrl = Uri.https('kauth.kakao.com', '/oauth/token', {
      'grant_type': 'authorization_code',
      'client_id': 'ae58524d5e3551dcc6608530c1e38422',
      'redirect_uri':
          'https://woolly-nosy-titanoceratops.glitch.me/callbacks/kakao/sign_in',
      'code': body['code'],
    });

    var response = await http.post(tokenUrl);
    Map<String, dynamic> accessTokenResult = jsonDecode(response.body);
    var tempUrl = Uri.parse(
        'https://woolly-nosy-titanoceratops.glitch.me/callbacks/kakao/token');
    var responseCustomToken = await http.post(tempUrl,
        body: {"accessToken": accessTokenResult['access_token']});

    final authResult =
        await _auth.signInWithCustomToken(responseCustomToken.body);
    // return authResult.user;
    user = authResult.user!;
    update();
  }

  Future<void> logOut() async {
    try {
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
