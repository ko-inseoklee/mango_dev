import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:google_sign_in/google_sign_in.dart';

class Authentication extends GetxController{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  var exitUser = false.obs;

  Authentication(){
    _auth.authStateChanges().listen((newUser) {
      print('Authentication - FirebaseAuth - AuthStateChanged - $newUser');
      user = newUser;
      exitUser = true.obs;
      update();
    }, onError: (e){
      print('Authentication - FirebaseAuth - AuthStateChanged - $e');
    });
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
        exitUser = true.obs;
        update();
      }
    } catch (e){
      print('Error reported: $e');
    }
    update();
  }


  Future<void> signOut() async {
    try{
      _auth.signOut();
      exitUser = false.obs;
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


}