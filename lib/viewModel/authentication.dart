import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';
import 'package:shared_preferences/shared_preferences.dart';


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

  Future<String> emailSignUp(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      user = userCredential.user!;
      authWay = 1;
      update();

      return "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print("The account already exists for that email.");
        return "already";
      } else {
        return "fail";
      }
    }
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
      // deleteAll(uid);
      await UserViewModel().deleteUser(uid);
      await RefrigeratorViewModel().deleteRefrigerator(rID: rID);

      _auth.currentUser!.delete();
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

  Future<bool> hasAlarmData(String uid) async {
    bool result = false;

    await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .get()
    .then((value){
      // print(value);
      // print(value.data());
      // print(value.data()!.containsKey("isAlarmOn"));
      result = value.data()!.containsKey("isAlarmOn");
    });

    return result;
  }

  Future<void> deleteAll(String uid) async {
    await UserViewModel().deleteUser(uid);
    // await RefrigeratorViewModel().deleteRefrigerator(rID: rID);
  }
}
