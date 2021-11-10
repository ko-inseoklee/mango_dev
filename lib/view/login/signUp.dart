import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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

  List<String> _pageTitle = ['개인정보 설정', '알림 주기 설정'];
  int _pageIndex = 0;

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

  refrigerationAlarmType _refrigerationAlarmType =
      refrigerationAlarmType.shelfLife;
  frozenAlarmType _frozenAlarmType = frozenAlarmType.shelfLife;
  roomTempAlarmType _roomTempAlarmType = roomTempAlarmType.shelfLife;

  int alarmIdx = 0;

  //For Upload data on Firebase
  String _userName = 'testName';
  int _refrigerationAlarm = 1;
  bool _isRefShelf = true;
  int _frozenAlarm = 1;
  bool _isFroShelf = true;
  int _roomTempAlarm = 1;
  bool _isRTShelf = true;
  String uuid = '';
  String _tokens = '';
  String _phoenNumber = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageTitle[_pageIndex],
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: MangoWhite,
      ),
      body: _pageIndex == 0
          ? setPersonalDataPage(context)
          : setAlarmPage(context),
    );
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
                                setState(() {
                                  requestedAuth = true;
                                  phoneReadOnly = true;
                                });
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
                              //'인증번호 확인'일 경우
                              if (authOk == false) {
                                PhoneAuthCredential phoneAuthCredential =
                                    PhoneAuthProvider.credential(
                                        verificationId: verificationId,
                                        smsCode: _optController.text);
                                signInWithPhoneAuthCredential(
                                    phoneAuthCredential);
                              }
                              //'다음'인경우
                              if (authOk == true) {}
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
                      //validation pass + 전화번호 인증 완료
                      setState(() {
                        _pageIndex = 1;
                      });
                      _userName = _nameController.text;
                      _phoenNumber = _telController.text;
                      _tokens = (await FirebaseMessaging.instance.getToken())!;
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

  Widget setAlarmPage(BuildContext context) {
    var _buttonWidth = 156.0;
    var _buttonHeight = 46.0;

    List<String> _storeType = ['냉장 제품', '냉동 제품', '실온 제품'];

    var idx = 0;

    return Container(
      child: Column(
        children: [
          Container(
            color: MangoWhite,
            width: deviceWidth,
            height: 60 * (deviceHeight / prototypeHeight),
            alignment: Alignment.center,
            child: Text(
              '제품 별 본인이 원하는 유통기한 알림기준과 일자를 설정해주세요. 알림 기준은 유통기한별 / 구매일자로부터 경과한 일수 두 가지가 있습니다.',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: MangoDisabledColor),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 7.0 * (deviceWidth / prototypeWidth)),
          Expanded(
              child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return alarmCard(_storeType[index], index);
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(height: 7.0 * (deviceWidth / prototypeWidth)),
                  itemCount: _storeType.length)),
          ColoredBox(
            color: MangoBehindColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: _buttonWidth * (deviceWidth / prototypeWidth),
                        height: _buttonHeight * (deviceWidth / prototypeWidth)),
                    child: ElevatedButton(
                        child: Text(
                          '이전',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              MangoDisabledContainerColor),
                        ),
                        onPressed: () {
                          setState(() {
                            //TODO. 뭔가 이상?
                            alarmIdx == 0
                                ? _auth
                                    .logOut()
                                    .then((value) => Get.off(Landing()))
                                : alarmIdx--;
                          });
                        })),
                SizedBox(
                  width: deviceWidth * 0.03,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                      width: _buttonWidth * (deviceWidth / prototypeWidth),
                      height: _buttonHeight * (deviceWidth / prototypeWidth)),
                  child: ElevatedButton(
                    child: Text(
                      '다음',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    onPressed: () async {
                      if (alarmIdx == 2) {

                        _auth.emailSignUp(email: _emailController.text, password: _passwordController.text); //로그인

                        uuid = Uuid().v4().toString();
                        String defaultImage = '-1';

                        await FirebaseFirestore.instance
                            .collection('user')
                            .doc(_auth.user!.uid)
                            .set({
                          'userID': _auth.user!.uid,
                          'creationTime': _auth.user!.metadata.creationTime!,
                          'refrigeratorID': uuid,
                          'isAlarmOn': true,
                          'refrigerationAlarm': _refrigerationAlarm,
                          'isRefShelf': _isRefShelf,
                          'frozenAlarm': _frozenAlarm,
                          'isFroShelf': _isFroShelf,
                          'roomTempAlarm': _roomTempAlarm,
                          'isRTShelf': _isRTShelf,
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
                        Get.off(GuidePage());
                      } else {
                        setState(() {
                          alarmIdx++;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 120 * (deviceHeight / prototypeHeight),
          )
        ],
      ),
    );
  }

  //parameter: Title name, type -> Refrigeration, Frozen, Room temperature.
  Widget alarmCard(String title, int type) {
    return Container(
      color: alarmIdx == type ? MangoWhite : MangoDisabledContainerColor,
      padding: EdgeInsets.fromLTRB(20.0 * (deviceWidth / prototypeWidth), 0,
          24.0 * (deviceWidth / prototypeWidth), 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 15.0 * (deviceWidth / prototypeWidth),
          ),
          Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: alarmIdx == type ? MangoBlack : MangoDisabledColor),
              ),
            ],
          ),
          SizedBox(
            height: 15.0 * (deviceWidth / prototypeWidth),
          ),
          Row(
            children: [
              Text(
                '표시기준',
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    color: alarmIdx == type ? MangoBlack : MangoDisabledColor),
              ),
              SizedBox(
                width: 150 * (deviceWidth / prototypeWidth),
              ),
              Text('알림일',
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color:
                          alarmIdx == type ? MangoBlack : MangoDisabledColor))
            ],
          ),
          SizedBox(
            height: 10.0 * (deviceWidth / prototypeWidth),
          ),
          Row(
            children: [
              Container(
                width: 85.0 * (deviceWidth / prototypeWidth),
                constraints: BoxConstraints(maxWidth: 120),
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Row(
                    children: [
                      Radio<dynamic>(
                        activeColor: alarmIdx == type
                            ? Theme.of(context).accentColor
                            : MangoDisabledColor,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: type == 0
                            ? refrigerationAlarmType.shelfLife
                            : type == 1
                                ? frozenAlarmType.shelfLife
                                : roomTempAlarmType.shelfLife,
                        groupValue: type == 0
                            ? _refrigerationAlarmType
                            : type == 1
                                ? _frozenAlarmType
                                : _roomTempAlarmType,
                        onChanged: (value) {
                          alarmIdx == type
                              ? setState(() {
                                  if (type == 0) {
                                    _isRefShelf = true;
                                    _refrigerationAlarmType = value;
                                  } else if (type == 1) {
                                    _isFroShelf = true;
                                    _frozenAlarmType = value;
                                  } else {
                                    _isRTShelf = true;
                                    _roomTempAlarmType = value;
                                  }
                                  // ignore: unnecessary_statements
                                })
                              : null;
                        },
                      ),
                      Text(
                        '유통기한',
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: alarmIdx == type
                                ? MangoBlack
                                : MangoDisabledColor),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 85.0 * (deviceWidth / prototypeWidth),
                constraints: BoxConstraints(maxWidth: 100),
                alignment: Alignment.bottomCenter,
                child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Row(
                      children: [
                        Radio<dynamic>(
                          activeColor: alarmIdx == type
                              ? Theme.of(context).accentColor
                              : MangoDisabledColor,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: type == 0
                              ? refrigerationAlarmType.registerDate
                              : type == 1
                                  ? frozenAlarmType.registerDate
                                  : roomTempAlarmType.registerDate,
                          groupValue: type == 0
                              ? _refrigerationAlarmType
                              : type == 1
                                  ? _frozenAlarmType
                                  : _roomTempAlarmType,
                          onChanged: (value) {
                            alarmIdx == type
                                ? setState(() {
                                    if (type == 0) {
                                      _isRefShelf = false;
                                      _refrigerationAlarmType = value;
                                    } else if (type == 1) {
                                      _isFroShelf = false;
                                      _frozenAlarmType = value;
                                    } else {
                                      _isRTShelf = false;
                                      _roomTempAlarmType = value;
                                    }
                                    // ignore: unnecessary_statements
                                  })
                                : null;
                          },
                        ),
                        Text(
                          '구매일',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(
                                  color: alarmIdx == type
                                      ? MangoBlack
                                      : MangoDisabledColor),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    )),
              ),
              SizedBox(
                width: 30 * (deviceWidth / prototypeWidth),
              ),
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                  width: 120 * (deviceWidth / prototypeWidth),
                ),
                child: OutlinedButton(
                  onPressed: () {
                    // ignore: unnecessary_statements
                    alarmIdx == type ? showCupertinoPicker(50, type) : null;
                  },
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                        alarmIdx != type ? MangoDisabledColorLight : null),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: type == 0
                              ? Text('$_refrigerationAlarm일 전')
                              : type == 1
                                  ? Text('$_frozenAlarm일 전')
                                  : Text('$_roomTempAlarm일 전')),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<dynamic> showCupertinoPicker(int index, int type) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(30.0),
          topRight: const Radius.circular(30.0),
        )),
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: 284 * (deviceHeight / prototypeHeight),
            child: Column(
              children: [
                dialogTopBar(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    '알림일 설정',
                    style: Theme.of(context)
                        .textTheme
                        .headline6, //TODO. CHANGE NEXT TIME
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTapDown: (details) {
                      if (alarmIdx < 2 && alarmIdx == type) {
                        setState(() {
                          alarmIdx++;
                        });
                      }
                      Get.back();
                    },
                    child: CupertinoPicker(
                      itemExtent: 32,
                      onSelectedItemChanged: (int newValue) {
                        print(newValue);
                        setState(() {
                          type == 0
                              ? _refrigerationAlarm = newValue + 1
                              : type == 1
                                  ? _frozenAlarm = newValue + 1
                                  : _roomTempAlarm = newValue + 1;
                        });
                      },
                      children: List<Widget>.generate(60, (int index) {
                        return Text(
                          (++index).toString(),
                          style: Theme.of(context).textTheme.headline5,
                        );
                      }),
                      scrollController: FixedExtentScrollController(
                          //initialItem: foods[index - 1].num - 1
                          initialItem: 1),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
