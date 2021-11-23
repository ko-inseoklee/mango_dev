import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/login/addUserInfo.dart';
import 'package:mangodevelopment/view/widget/dialog/confrirmDialog.dart';
import 'package:mangodevelopment/view/widget/dialog/dialog.dart';
import 'package:mangodevelopment/viewModel/authentication.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';
import 'package:uuid/uuid.dart';

import '../../app.dart';
import '../../color.dart';
import '../../landing.dart';
import 'guide.dart';

enum refrigerationAlarmType { shelfLife, registerDate }
enum frozenAlarmType { shelfLife, registerDate }
enum roomTempAlarmType { shelfLife, registerDate }

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  Authentication _auth = Get.find<Authentication>();
  FirebaseAuth _authPhone = FirebaseAuth.instance;

  final _sizeOfText = 3;
  final _sizeOfBox = 10;

  final _formKey = GlobalKey<FormState>();
  final _formPhoneKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _telController = TextEditingController();
  final _optController = TextEditingController();

  bool authOk = false; // 가입완료 변수
  bool requestedAuth = false; //폰인증 요청을 보냈는지 여부
  bool phoneReadOnly = false; //전화번호 수정 가능 변수
  late String verificationId;

  //For Upload data on Firebase
  String _userName = 'testName';
  String uuid = '';
  String _tokens = '';
  String _phoenNumber = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '개인정보 설정',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: MangoWhite,
        ),
        body: setPersonalDataPage(context));
  }

  Widget setPersonalDataPage(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(24)),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: double.infinity),
                child: Text(
                  '환영합니다! \n회원정보를 입력해주세요',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(_sizeOfBox),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: double.infinity),
                child: Text(
                  '이메일',
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(_sizeOfText),
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val!.isEmpty) {
                    return "이메일을 입력해주세요";
                  }
                  if (!RegExp(
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                      .hasMatch(val)) {
                    return '잘못된 이메일 형식입니다.';
                  }
                },
              ),
              SizedBox(
                height: ScreenUtil().setHeight(_sizeOfBox),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: double.infinity),
                child: Text(
                  '비밀번호',
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(_sizeOfText),
              ),
              TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val!.isEmpty) {
                    return "비밀번호를 입력해주세요";
                  }
                  if (!RegExp(r'^[A-Za-z0-9+]*$').hasMatch(val)) {
                    return "영문,숫자 모두 포함해주세요";
                  }
                  if (val.length < 8) {
                    return "8자 이상 입력해주세요";
                  }
                },
              ),
              SizedBox(
                height: ScreenUtil().setHeight(_sizeOfBox),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: double.infinity),
                child: Text(
                  '닉네임',
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(_sizeOfText),
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val!.isEmpty) {
                    return "닉네임을 입력해주세요";
                  }
                },
              ),
              SizedBox(
                height: ScreenUtil().setHeight(_sizeOfBox),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: double.infinity),
                child: Text(
                  '전화번호',
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(_sizeOfText),
              ),
              Form(
                key: _formPhoneKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: phoneReadOnly,
                        controller: _telController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            border: OutlineInputBorder(),
                            hintText: '5555215554'),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "전화번호를 입력해주세요";
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(10),
                    ),
                    ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                            width: 100, height: ScreenUtil().setHeight(50)),
                        child: ElevatedButton(
                            child: Text('인증요청'),
                            onPressed: () async {
                              if (_formPhoneKey.currentState!.validate()) {
                                //all validation pass
                                await _authPhone.verifyPhoneNumber(
                                    timeout: const Duration(seconds: 120),
                                    phoneNumber: "+1" + _telController.text,
                                    verificationCompleted:
                                        (phoneAuthCredential) async {
                                      print('otp 문자옴');
                                    },
                                    verificationFailed: (verificationFailed) {
                                      print(verificationFailed.code);
                                      print('코드 발송 실패');
                                    },
                                    codeSent:
                                        (verificationId, resendingToken) async {
                                      print('코드 보냄');
                                      Get.snackbar("MESSAGE",
                                          "${_telController.text} 로 인증코드를 발송하였습니다. 문자가 올때까지 잠시만 기다려 주세요.");
                                      setState(() {
                                        requestedAuth = true;
                                        // FocusScope.of(context).requestFocus(otpFocusNode);
                                        this.verificationId = verificationId;
                                        print(
                                            "verification id: $verificationId");
                                      });
                                    },
                                    codeAutoRetrievalTimeout:
                                        (String verificationId) {});
                                setState(() {
                                  requestedAuth = true;
                                });
                              }
                            }))
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(_sizeOfBox),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: double.infinity),
                child: Text(
                  '인증번호 입력',
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(_sizeOfText),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _optController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) {},
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(10),
                  ),
                  Visibility(
                    visible: requestedAuth,
                    child: ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                            width: 100, height: ScreenUtil().setHeight(50)),
                        child: ElevatedButton(
                            child: Text('확인'),
                            onPressed: () async {
                              PhoneAuthCredential phoneAuthCredential =
                                  PhoneAuthProvider.credential(
                                      verificationId: verificationId,
                                      smsCode: _optController.text);
                              signInWithPhoneAuthCredential(
                                  phoneAuthCredential);
                            }
                            //style: ButtonStyle(),
                            )),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(40),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: double.infinity,
                    minHeight: ScreenUtil().setHeight(60)),
                child: ElevatedButton(
                  child: const Text('다음'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && authOk == true) {
                      //validation pass + 전화번호 인증 완료 되었을 때,
                      _userName = _nameController.text;
                      _phoenNumber = _telController.text;
                      _tokens = (await FirebaseMessaging.instance.getToken())!;

                      //email 회원가입
                      _auth
                          .emailSignUp(
                          email: _emailController.text,
                          password: _passwordController.text)
                          .then((value) async {
                        if (value == "success") {

                          uuid = Uuid().v4().toString();
                          String defaultImage = '-1';

                          await FirebaseFirestore.instance
                              .collection('user')
                              .doc(_auth.user!.uid)
                              .set({
                            'userID': _auth.user!.uid,
                            'creationTime': _auth.user!.metadata.creationTime!,
                            'refrigeratorID': uuid,
                            'lastSignIn': _auth.user!.metadata.lastSignInTime!,
                            'profileImageReference': defaultImage,
                            'userName': _userName,
                            'phoneNumber': _phoenNumber,
                            'tokens': _tokens,
                          });

                          await RefrigeratorViewModel()
                              .createRefrigeratorID(_auth.user!.uid, uuid);
                          //TODO. refirgeratorController()
                          // await refrigeratorController()
                          //     .makeRefInfoDocument(refID: uuid);

                          //Get TO
                          await _auth.loadId();
                          Get.off(Landing());

                        } else {
                          print("이미 가입되어 있는 이메일입니다.");
                          Get.dialog(ConfirmDialog(
                              contentText: "이미 가입되어 있는 이메일입니다.",
                              onTapOK: () {
                                Get.back();
                              }));
                        }
                      });

                    }
                    if (authOk == false) {
                      Get.dialog(ConfirmDialog(
                          contentText: "전화번호 인증을 완료해주세요",
                          onTapOK: () {
                            Get.back();
                          }));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      final authCredential =
          await _authPhone.signInWithCredential(phoneAuthCredential);
      if (authCredential.user != null) {
        await _authPhone.currentUser!.delete();
        // print('auth 정보삭제');
        await _authPhone.signOut();
        // print('phone 로그인된 것 로그아웃');

        Get.dialog(ConfirmDialog(
            contentText: "인증이 성공적으로 완료되었습니다",
            onTapOK: () {
              setState(() {
                // print('인증완료 및 로그인 성공');
                phoneReadOnly = true;
                authOk = true;
              });
              Get.back();
            }));
      }
    } on FirebaseAuthException catch (e) {
      Get.dialog(ConfirmDialog(
          contentText: "인증에 실패하셨습니다\n인증번호 전송은 총 4회까지 무료입니다",
          onTapOK: () {
            setState(() {
              phoneReadOnly = false;
            });
            Get.back();
          })).then((value) {
        setState(() {
          authOk = false;
        });
      });
    }
  }
}
