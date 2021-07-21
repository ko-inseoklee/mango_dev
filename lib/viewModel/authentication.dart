import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication extends GetxController{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  late Future<String> id;

  Authentication() {
    _auth.authStateChanges().listen((newUser) {
      print('Authentication - FirebaseAuth - AuthStateChanged - $newUser');
      user = newUser;
      update();
    }, onError: (e){
      print('Authentication - FirebaseAuth - AuthStateChanged - $e');
    });
  }

  Future<String> loadId() async{
    final SharedPreferences prefss = await prefs;
    final String id = (prefss.getString('id') ?? user!.uid);

    return prefss.setString('id', id).then((value) {return id;});
  }

  Future<void> googleLogin() async{
    try{
      UserCredential userCredential;
      if(kIsWeb){
        GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleAuthProvider);
      }else{
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

        final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken
        );

        final authResult = await _auth.signInWithCredential(credential);

        user = authResult.user!;
        update();
      }
    } catch (e){
      print('Error reported: $e');
    }
    update();
  }

  Future<void> logOut() async{
    try{
      _auth.signOut();
      prefs.then((SharedPreferences pref) => pref.remove('id'));
      update();
    }catch (e){
      print('exception error: $e');
    }
  }

  Future<void> signOut() async {
    try{
      deleteAll(user!.uid);
      _auth.signOut();
      prefs.then((SharedPreferences pref) => pref.remove('id'));
      update();
    }catch (e){
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

  Future<void> deleteAll(String uid) async{
    await UserViewModel().deleteUser(uid);
  }


}