import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:get/get.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/all.dart' as kakao;
import 'package:mangodevelopment/view/widget/dialog/confrirmDialog.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../color.dart';

class Authentication extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  int authWay = 0;

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

  Future<String> emailLogin(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      user = userCredential.user!;
      authWay = 1;
      update();
      return "success";
    } on FirebaseAuthException catch (e) {
      return "fail";
    }
  }

  Future<void> emailSignUp(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      user = userCredential.user!;
      authWay = 1;
      update();

      print("Signed Up");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print("The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        print("The account already exists for that email.");
      } else {
        print("Something Went Wrong.");
      }
    } catch (e) {
      print(e);
    }
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
