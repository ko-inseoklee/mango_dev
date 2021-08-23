import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/color.dart';
import 'package:mangodevelopment/app.dart';
import 'package:mangodevelopment/landing.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';
import 'package:mangodevelopment/view/login/guide.dart';
import 'package:mangodevelopment/view/widget/dialog/dialog.dart';
import 'package:mangodevelopment/viewModel/authentication.dart';
import 'package:uuid/uuid.dart';

enum refrigerationAlarmType { shelfLife, registerDate }
enum frozenAlarmType { shelfLife, registerDate }
enum roomTempAlarmType { shelfLife, registerDate }

class AddUserInfoPage2 extends StatefulWidget {
  @override
  _AddUserInfoPage2State createState() => _AddUserInfoPage2State();
}

class _AddUserInfoPage2State extends State<AddUserInfoPage2> {
  Authentication _auth = Get.find<Authentication>();
  FirebaseAuth _authPhone = FirebaseAuth.instance;

  List<String> _pageTitle = ['개인정보 설정','본인인증','알림 주기 설정'];
  var _contentWidth = 350.0;

  int _pageIndex = 0;
  final _nameController = TextEditingController();

  final _telController = TextEditingController();
  final _optController = TextEditingController();
  bool authOk = false; // 가입완료 변수
  bool requestedAuth = false; //폰인증 요청을 보냈는지 여부
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MangoBehindColor,
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
            : _pageIndex == 1
            ? setPhonePage(context)
            : setAlarmPage(context));
  }

  Widget setPersonalDataPage(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(20), //TODO. 20??
      color: MangoWhite,
      child: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
              width: _contentWidth * (deviceWidth * deviceHeight),
              child: Text(
                '망고에서 사용하실 이름을 입력해주세요.',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
              width: _contentWidth * (deviceWidth * deviceHeight),
              child: Text(
                '본인 인증을 위해 필요합니다.',
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: MangoDisabledColorDark),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  0,
                  14 * (deviceWidth / prototypeWidth),
                  0,
                  33 * (deviceWidth / prototypeWidth)),
              width: _contentWidth * (deviceWidth * deviceHeight),
              child: TextField(
                maxLength: 12,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[A-z]'))
                ],
                controller: _nameController,
                decoration: InputDecoration(
                  errorBorder:
                  OutlineInputBorder(borderSide: BorderSide(width: 1.0)),
                  border: OutlineInputBorder(),
                  focusedBorder:
                  OutlineInputBorder(borderSide: BorderSide(width: 1.0)),
                ),
              ),
            ),
            ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                    width: deviceWidth,
                    height: 46.0 * (deviceWidth / prototypeWidth)),
                child: ElevatedButton(
                  //TODO: It will be change '인증' after adding phone number authentication.
                    child: Text('다음'),
                    onPressed: () async {
                      setState(() {
                        // 나중에 사용할 것. 두번째 페이지 변경
                        _pageIndex = 1;
                      });
                      _userName = _nameController.text;
                      _tokens = (await FirebaseMessaging.instance.getToken())!;
                      //_pageIndex = 1;
                    }
                )),
          ],
        ),
      ),
    );
  }

  Future<String?> getDeviceToken() async {
    //save device token
    String? token = await FirebaseMessaging.instance.getToken();
    return token;
  }

  Widget setPhonePage(BuildContext context){

    return ListView(
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
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                            0, 14 * (deviceWidth / prototypeWidth), 0, 0),
                        // width: _contentWidth * (deviceWidth * deviceHeight),
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
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                            width: 100, height: ScreenUtil().setHeight(60)),
                        child: ElevatedButton(
                            child: Text('인증요청'),
                            onPressed: () async {
                              // setState(() {
                              //   requestedAuth = true;
                              // });
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
                                      print("verification id: $verificationId");
                                    });
                                  },
                                  codeAutoRetrievalTimeout:
                                      (String verificationId) {});
                            }))
                  ],
                ),
                Column(
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
                        0,
                      ),
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
                Visibility(
                  visible: requestedAuth,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                            width: deviceWidth,
                            height: 46.0 * (deviceWidth / prototypeWidth)),
                        child: ElevatedButton(
                            child:
                            authOk == true ? Text('다음') : Text('인증번호 확인'),
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
                              //'다음'인경
                              if (authOk == true) {
                                setState(() {
                                  _pageIndex = 2;
                                });
                                //TODO. DB에 phone정보도 넣어야 된다.
                              }
                            }
                          //style: ButtonStyle(),
                        )),
                  ),
                ),
              ])),
        ),
      ],
    );
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      final authCredential =
      await _authPhone.signInWithCredential(phoneAuthCredential);
      if (authCredential.user != null) {
        await _authPhone.currentUser!.delete();
        print('auth 정보삭제');
        await _authPhone.signOut();
        print('phone 로그인된 것 로그아웃');
        if(_auth.authWay == 0){ // google login
          await _auth.googleLogin();
          print("google login again");
        }

        Get.defaultDialog(
          title: "",
          content: Column(
            children: [
              Text(
                "인증이 성공적으로 완료되었습니다.",
                style: Theme.of(context).textTheme.subtitle2,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 25, 8, 0),
                child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: deviceWidth,
                        height: 46.0 * (deviceWidth / prototypeWidth)),
                    child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('확인'))),
              )
            ],
          ),
        ).then((value) {
          setState(() {
            print('인증완료 및 로그인 성공');
            authOk = true;
          });
        });
      }
    } on FirebaseAuthException catch (e) {
      print('인증실패..로그인실패');
      Get.defaultDialog(
        title: "",
        content: Column(
          children: [
            Text(
              "인증에 실패하셨습니다.",
              style: Theme.of(context).textTheme.subtitle2,
            ),
            Text(
              "인증번호 전송은 총 4회까지 무료입니다.",
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: MangoErrorColor),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 25, 8, 0),
              child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                      width: deviceWidth,
                      height: 46.0 * (deviceWidth / prototypeWidth)),
                  child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text('확인'))),
            )
          ],
        ),
      ).then((value){
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
                                .signOut()
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
