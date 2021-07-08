import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_pickers/helpers/show_number_picker.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/color.dart';
import 'package:mangodevelopment/app.dart';
import 'package:mangodevelopment/landing.dart';
import 'package:mangodevelopment/view/login/guide.dart';
import 'package:mangodevelopment/view/widget/setting/settingMenu.dart';
import 'package:mangodevelopment/viewModel/authentication.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';
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
                          alarmIdx == type ?
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
                          // ignore: unnecessary_statements
                          }) : null;
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
                            alarmIdx == type?
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
                            // ignore: unnecessary_statements
                            }): null;
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
                        alarmIdx != type ? MangoDisabledColorLight : null
                    ),
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
          topLeft: const Radius.circular(10.0),
          topRight: const Radius.circular(10.0),
        )),
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: 284 * (deviceHeight / prototypeHeight),
            child: Column(
              children: [
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
                  child: CupertinoPicker(
                    itemExtent: 32,
                    onSelectedItemChanged: (int newValue) {
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
                        ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
