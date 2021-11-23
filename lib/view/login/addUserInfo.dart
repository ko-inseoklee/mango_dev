import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/color.dart';
import 'package:mangodevelopment/app.dart';
import 'package:mangodevelopment/landing.dart';
import 'package:mangodevelopment/view/login/guide.dart';
import 'package:mangodevelopment/view/widget/dialog/dialog.dart';
import 'package:mangodevelopment/viewModel/authentication.dart';

enum refrigerationAlarmType { shelfLife, registerDate }
enum frozenAlarmType { shelfLife, registerDate }
enum roomTempAlarmType { shelfLife, registerDate }

class AddUserInfoPage extends StatefulWidget {
  @override
  _AddUserInfoPageState createState() => _AddUserInfoPageState();
}

class _AddUserInfoPageState extends State<AddUserInfoPage> {
  Authentication _auth = Get.find<Authentication>();

  refrigerationAlarmType _refrigerationAlarmType =
      refrigerationAlarmType.shelfLife;
  frozenAlarmType _frozenAlarmType = frozenAlarmType.shelfLife;
  roomTempAlarmType _roomTempAlarmType = roomTempAlarmType.shelfLife;

  int alarmIdx = 0;

  //For Upload data on Firebase
  int _refrigerationAlarm = 1;
  bool _isRefShelf = true;
  int _frozenAlarm = 1;
  bool _isFroShelf = true;
  int _roomTempAlarm = 1;
  bool _isRTShelf = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MangoBehindColor,
        appBar: AppBar(
          title: Text(
            '알림 주기 설정',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: MangoWhite,
          automaticallyImplyLeading: false,
        ),
        body: setAlarmPage(context));
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
            height: ScreenUtil().setHeight(60),
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
          SizedBox(
            height: ScreenUtil().setHeight(7.0),
          ),
          Expanded(
              child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return alarmCard(_storeType[index], index);
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(
                        height: ScreenUtil().setHeight(7.0),
                      ),
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
                  width: ScreenUtil().setWidth(10),
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
                        //회원가입 (emailSignUp)

                        await FirebaseFirestore.instance
                            .collection('user')
                            .doc(_auth.user!.uid)
                            .update({
                          'isAlarmOn': true,
                          'refrigerationAlarm': _refrigerationAlarm,
                          'isRefShelf': _isRefShelf,
                          'frozenAlarm': _frozenAlarm,
                          'isFroShelf': _isFroShelf,
                          'roomTempAlarm': _roomTempAlarm,
                          'isRTShelf': _isRTShelf,
                        });

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
            height: ScreenUtil().setHeight(120),
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
            height: ScreenUtil().setHeight(15),
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
            height: ScreenUtil().setHeight(15),
          ),
          Row(
            children: [
              Text(
                '표시기준',
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    color: alarmIdx == type ? MangoBlack : MangoDisabledColor),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(150),
              ),
              Text('알림일',
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color:
                          alarmIdx == type ? MangoBlack : MangoDisabledColor))
            ],
          ),
          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),
          Row(
            children: [
              Container(
                width: ScreenUtil().setWidth(85),
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
                width: ScreenUtil().setWidth(85),
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
                width: ScreenUtil().setWidth(30),
              ),
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                  width: ScreenUtil().setWidth(120),
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
                              ? _refrigerationAlarmType ==
                                      refrigerationAlarmType.shelfLife
                                  ? Text('$_refrigerationAlarm일 전')
                                  : Text('$_refrigerationAlarm일 후')
                              : type == 1
                                  ? _frozenAlarmType ==
                                          frozenAlarmType.shelfLife
                                      ? Text('$_frozenAlarm일 전')
                                      : Text('$_frozenAlarm일 후')
                                  : _roomTempAlarmType ==
                                          roomTempAlarmType.shelfLife
                                      ? Text('$_roomTempAlarm일 전')
                                      : Text('$_roomTempAlarm일 후')),
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
            height: ScreenUtil().setHeight(284),
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
