import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:google_sign_in/google_sign_in.dart';

class Authentication extends GetxController{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  Authentication(){
    _auth.authStateChanges().listen((newUser) {
      print('Authentication - FirebaseAuth - AuthStateChanged - $newUser');
      user = newUser;
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
        update();
      }
    } catch (e){
      print('Error reported: $e');
    }
    update();
  }
  // Future<User?> googleLogin() async{
  //   try{
  //     UserCredential userCredential;
  //     if(kIsWeb){
  //       GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
  //       userCredential = await _auth.signInWithPopup(googleAuthProvider);
  //     }else{
  //       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //       final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
  //
  //       final credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth.accessToken,
  //         idToken: googleAuth.idToken
  //       );
  //
  //       final authResult = await _auth.signInWithCredential(credential);
  //
  //       return authResult.user;
  //     }
  //   } catch (e){
  //     print('Error reported: $e');
  //   }
  // }


  Future<void> signOut() async {
    try{
      _auth.signOut();
      update();
    }catch (e){
      print('exception error: $e');
    }
  }

  Future<bool> hasData(String uid) async {
    bool result = false;

    await FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .get()
        .then((value) => result = value.exists);

    return result;
  }


}