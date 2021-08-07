import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/color.dart';

import '../../app.dart';

class TelTestPage extends StatefulWidget {
  @override
  _TelTestPageState createState() => _TelTestPageState();
}

class _TelTestPageState extends State<TelTestPage> {
  final _telController = TextEditingController();
  final _optController = TextEditingController();
  bool authOk = false; // 가입완료 변수
  bool requestedAuth = false; //폰인증 요청을 보냈는지 여부
  late String verificationId;

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var _contentWidth = 350.0;

    return Scaffold(
        appBar: AppBar(
          title: Text('본인인증'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                  child: Column(children: [
                Container(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                  width: _contentWidth * (deviceWidth * deviceHeight),
                  child: Text(
                    '휴대폰 인증을 완료해주세요.',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
                  width: _contentWidth * (deviceWidth * deviceHeight),
                  child: Text(
                    '계정 도용을 막기 위한 본인 인증 절차입니다.',
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: MangoDisabledColorDark),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                  width: _contentWidth * (deviceWidth * deviceHeight),
                  child: Text(
                    '휴대폰 번호',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(color: MangoDisabledColorDark),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                      0, 14 * (deviceWidth / prototypeWidth), 0, 0),
                  width: _contentWidth * (deviceWidth * deviceHeight),
                  child: TextField(
                    maxLength: 11,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                    ],
                    controller: _telController,
                    decoration: InputDecoration(
                      hintText: '5555215554',
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0)),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0)),
                    ),
                  ),
                ),
                Visibility(
                  visible: requestedAuth,
                  child: Column(
                    children: [
                      Container(
                        width: _contentWidth * (deviceWidth * deviceHeight),
                        child: Text(
                          '인증번호 입력',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(color: MangoDisabledColorDark),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            0,
                            14 * (deviceWidth / prototypeWidth),
                            0,
                            0,),
                        width: _contentWidth * (deviceWidth * deviceHeight),
                        child: TextField(
                          maxLength: 6,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                          ],
                          controller: _optController,
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1.0)),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                          width: deviceWidth,
                          height: 46.0 * (deviceWidth / prototypeWidth)),
                      child: ElevatedButton(
                          child: requestedAuth == false? Text('인증요청') : Text('다음'),
                          onPressed: () async {
                            // setState(() {
                            //   requestedAuth = true;
                            // });
                            //'인증요청'일 경우
                            if(requestedAuth == false){
                              await _auth.verifyPhoneNumber(
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
                                  codeSent: (verificationId, resendingToken) async {
                                    print('코드 보냄');
                                    Get.snackbar("MESSAGE",
                                        "${_telController.text} 로 인증코드를 발송하였습니다. 문자가 올때까지 잠시만 기다려 주세요.");
                                    setState(() {
                                      requestedAuth = true;
                                      // FocusScope.of(context).requestFocus(otpFocusNode);
                                      this.verificationId = verificationId;
                                      print("verification id: $verificationId");
                                    });
                                  },
                                  codeAutoRetrievalTimeout:
                                      (String verificationId) {});
                            }
                            //'다음'일 경우
                            else{
                              //if(authOk == true 일때)
                              // PhoneAuthCredential phoneAuthCredential =
                              // PhoneAuthProvider.credential(
                              //     verificationId: verificationId,
                              //     smsCode: _optController.text);
                              // signInWithPhoneAuthCredential(phoneAuthCredential);
                              // if(authOk == false 일때)
                              // case 1) 폰 번호를 다시 입력하게 해서, 인증코드를 다시 받을 수 있게 하거나
                              // case 2) 인증번호를 다시 입력하능하게 하거나
                            }
                          }
                          //style: ButtonStyle(),
                          )),
                ),
              ])),
            ),
          ],
        ));
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      if (authCredential.user != null) {
        setState(() {
          print('인증완료 및 로그인 성공');
          authOk = true;
          requestedAuth = false;
        });
        await _auth.currentUser!.delete();
        print('auth 정보삭제');
        _auth.signOut();
        print('phone 로그인된 것 로그아웃');
      }
    } on FirebaseAuthException catch (e) {
      print('인증실패..로그인실패');

      await Get.dialog(
        Text('e'),
      );
    }
  }
}
