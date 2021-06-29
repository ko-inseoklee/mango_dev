import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/color.dart';
import 'package:mangodevelopment/app.dart';
import 'package:mangodevelopment/landing.dart';
import 'package:mangodevelopment/view/login/guide.dart';
import 'package:mangodevelopment/viewModel/authentication.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:uuid/uuid.dart';

enum refrigerationAlarmType { shelfLife, registerDate }
enum frozenAlarmType { shelfLife, registerDate }
enum roomTempAlarmType { shelfLife, registerDate }

class AddUserInfoPage extends StatefulWidget {
  @override
  _AddUserInfoPageState createState() => _AddUserInfoPageState();
}

class _AddUserInfoPageState extends State<AddUserInfoPage> {
  Authentication _auth = Get.find<Authentication>();
  final userViewModelController = Get.put(UserViewModel());

  List<String> _pageTitle = ['개인정보 설정', '알림 주기 설정'];

  final List<Map<String, dynamic>> _items = [
    {'value': '3', 'label': '3일 전'},
    {'value': '7', 'label': '7일 전'},
    {'value': '10', 'label': '10일 전'},
    {'value': '15', 'label': '15일 전'}
  ];

  bool _isFirstPage = true;
  final _nameController = TextEditingController();

  refrigerationAlarmType _refrigerationAlarmType =
      refrigerationAlarmType.shelfLife;
  frozenAlarmType _frozenAlarmType = frozenAlarmType.shelfLife;
  roomTempAlarmType _roomTempAlarmType = roomTempAlarmType.shelfLife;

  int alarmIdx = 0;

  //For Upload data on Firebase
  String _userName = 'testName';
  int _refrigerationAlarm = 0;
  bool _isRefShelf = true;
  int _frozenAlarm = 0;
  bool _isFroShelf = true;
  int _roomTempAlarm = 0;
  bool _isRTShelf = true;
  String uuid = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MangoBehindColor,
        appBar: AppBar(
          title: Text(
            _pageTitle[0],
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: MangoWhite,
        ),
        body: _isFirstPage
            ? setPersonalDataPage(context)
            : setAlarmPage(context));
  }

  Widget setPersonalDataPage(BuildContext context) {
    var _contentWidth = 350.0;

    return Container(
      padding: EdgeInsets.all(20), //TODO. 20??
      color: MangoWhite,
      child: Center(
        child: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.only(top: 20 * (deviceWidth / prototypeWidth)),
              width: _contentWidth * (deviceWidth * deviceHeight),
              child: Text('망고에서 사용하실 이름을 입력해주세요.'),
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
                    onPressed: () {
                      setState(() {
                        // 나중에 사용할 것. 두번째 페이지 변경
                        _isFirstPage = false;
                      });
                      _userName = _nameController.text;
                      _isFirstPage = false;
                    }
                    //style: ButtonStyle(),
                    )),
          ],
        ),
      ),
    );
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
        SizedBox(
          height: 7.0 * (deviceWidth / prototypeWidth),
        ),
        alarmCard(_storeType[0], 0),
        SizedBox(
          height: 7.0 * (deviceWidth / prototypeWidth),
        ),
        alarmCard(_storeType[1], 1),
        SizedBox(
          height: 7.0 * (deviceWidth / prototypeWidth),
        ),
        alarmCard(_storeType[2], 2),
        SizedBox(
          height: 7.0 * (deviceWidth / prototypeWidth),
        ),
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
                      await userViewModelController.makeUserInformation(
                        _auth.user!.uid,
                        _auth.user!.metadata.creationTime!,
                        uuid,
                        _refrigerationAlarm,
                        _isRefShelf,
                        _frozenAlarm,
                        _isFroShelf,
                        _roomTempAlarm,
                        _isRTShelf,
                        _auth.user!.metadata.lastSignInTime!,
                        defaultImage,
                        _userName,
                      );
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
        )
      ],
    ));
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
                          setState(() {
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
                          });
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
                            setState(() {
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
                            });
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
                width: 45 * (deviceWidth / prototypeWidth),
              ),
              Container(
                  width: 100,
                  child: SelectFormField(
                    decoration: InputDecoration(
                        fillColor:
                            alarmIdx == type ? MangoBlack : MangoDisabledColor),
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color:
                            alarmIdx == type ? MangoBlack : MangoDisabledColor),
                    type: SelectFormFieldType.dropdown,
                    initialValue: '0일 전',
                    hintText: '0일 전',
                    //items: _items, //TODO.
                      // onChanged: (val) {
                      //   if (type == 0) {
                      //     _refrigerationAlarm = int.parse(val);
                      //   } else if (type == 1) {
                      //     _frozenAlarm = int.parse(val);
                      //   } else {
                      //     _roomTempAlarm = int.parse(val);
                      //   }
                      // },
                  )
              )
            ],
          ),
        ],
      ),
    );
  }
}
