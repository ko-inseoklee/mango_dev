import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:google_sign_in/google_sign_in.dart';

class Authentication extends GetxController{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //late StreamSubscription userAuthSub; //TODO. 인석에게 물어보
  late User user;

  Authentication(){
    _auth.authStateChanges().listen((newUser) {
      print('Authentication - FirebaseAuth - AuthStateChanged - $newUser');
      user = newUser!;
      update();
    }, onError: (e){
      print('Authentication - FirebaseAuth - AuthStateChanged - $e');
    });
  }

  Future<User?> googleLogin() async{
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

        return authResult.user;
      }
    } catch (e){
      print('Error reported: $e');
    }
  }


  Future<void> singOut() async {
    try{
      _auth.signOut();
      update();
    }catch (e){
      print('exception error: $e');
    }
  }


}