import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangodevelopment/view/widget/appBar.dart';
import 'package:mangodevelopment/view/widget/dialog/dialog.dart';
import 'package:mangodevelopment/view/widget/setting/settingMenu.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/viewModel/authentication.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

import '../../app.dart';
import '../../color.dart';

enum refrigerationAlarmType { shelfLife, registerDate }
enum frozenAlarmType { shelfLife, registerDate }
enum roomTempAlarmType { shelfLife, registerDate }

class SettingAlarmPage extends StatefulWidget {
  final String title;

  const SettingAlarmPage({Key? key, required this.title}) : super(key: key);

  @override
  _SettingAlarmPageState createState() => _SettingAlarmPageState();
}

class _SettingAlarmPageState extends State<SettingAlarmPage> {
  bool isSwitched = false;
  bool isExpanded = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  UserViewModel _userViewModel = Get.find<UserViewModel>();
  Authentication _auth = Get.find<Authentication>();

  refrigerationAlarmType _refrigerationAlarmType =
      refrigerationAlarmType.shelfLife;
  frozenAlarmType _frozenAlarmType = frozenAlarmType.shelfLife;
  roomTempAlarmType _roomTempAlarmType = roomTempAlarmType.shelfLife;

  List<String> _storeType = ['냉장 제품', '냉동 제품', '실온 제품'];

  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("알람 관리"),
        centerTitle: true,
        leading: IconButton(
          icon: Text('취소'),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: Text('저장'),
            onPressed: () async {
              await _userViewModel.updateUserInfo(_auth.user!.uid);
              Get.back();
            },
          ),
        ],
      ),
      backgroundColor: MangoWhite,
      body: Container(
        height: deviceHeight,
        width: deviceWidth,
        child: ListView(children: [
          Column(
            children: [
              Container(
                child: Text(
                  '알림 설정',
                  style: Theme.of(context).textTheme.caption!.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0,
                      ),
                ),
                padding: EdgeInsets.fromLTRB(
                    15, 20 * deviceWidth / prototypeWidth, 0, 0),
                alignment: Alignment.centerLeft,
              ),
              //TODO: Push Notification 기능 추가
              settingMenu(
                menuName: '푸시 알림 설정',
                onTap: () {},
                trailing: Switch(
                  value: _userViewModel.user.value.isAlarmOn,
                  activeColor: Orange400,
                  onChanged: (value) {
                    setState(() {
                      _userViewModel.isAlarmOn = value;
                    });
                  },
                ),
                trailingWidth: 60,
                isActive: true,
              ),
              settingMenu(
                menuName: '알림 주기 설정',
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                trailing: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Orange400,
                ),
                trailingWidth: 60,
                isActive: true,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                child: isExpanded
                    ? ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: 60,
                            maxHeight: ScreenUtil().setHeight(450)),
                        child: Column(children: [
                          Expanded(
                              child: ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return alarmCard(_storeType[index], index);
                            },
                            itemCount: _storeType.length,
                            //children: [setAlarm()],
                          ))
                        ]),
                      )
                    : SizedBox(
                        height: 0.001,
                      ),
              ),

              settingMenu(
                menuName: '알림음',
                onTap: () => comingSoon(context),
                trailing: Text('MANGO'),
                trailingWidth: 100,
                isActive: true,
              )
            ],
          ),
        ]),
      ),
    );
  }

  Widget alarmCard(String title, int type) {
    return Column(children: [
      Container(
          padding: EdgeInsets.fromLTRB(20, 15, 0, 0),
          child: Row(
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(color: Orange400, fontWeight: FontWeight.w700),
              ),
            ],
          )),
      settingMenu(
        menuName: '유통기한 기준',
        onTap: () {},
        trailing: alarmTextButton(type, true),
        trailingWidth: 100,
        isActive: type == 0
            ? _userViewModel.user.value.isRefShelf
            : type == 1
                ? _userViewModel.user.value.isFroShelf
                : _userViewModel.user.value.isRTShelf,
      ),
      settingMenu(
        menuName: '구매일 기준',
        onTap: () {},
        trailing: alarmTextButton(type, false),
        trailingWidth: 100,
        isActive: type == 0
            ? !_userViewModel.user.value.isRefShelf
            : type == 1
                ? !_userViewModel.user.value.isFroShelf
                : !_userViewModel.user.value.isRTShelf,
      ),
    ]);
  }

  Widget alarmTextButton(int type, bool value){
    return TextButton(
        onPressed: () {
          setState(() {
            type == 0
                ? _userViewModel.isRefShelf = value
                : type == 1
                ? _userViewModel.isFroShelf = value
                : _userViewModel.isRTShelf = value;
          });
          showCupertinoPicker(2, type);
        },
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: 50,
              child: type == 0
                  ? _userViewModel.user.value.isRefShelf == value
                  ? Text(
                _userViewModel.user.value.refrigerationAlarm
                    .toString() +
                    "일 전",
                style: Theme.of(context).textTheme.subtitle2,
              )
                  : Text('-')
                  : type == 1
                  ? _userViewModel.user.value.isFroShelf == value
                  ? Text(
                _userViewModel.user.value.frozenAlarm
                    .toString() +
                    "일 전",
                style: Theme.of(context).textTheme.subtitle2,
              )
                  : Text('-')
                  : _userViewModel.user.value.isRTShelf == value
                  ? Text(
                _userViewModel.user.value.roomTempAlarm
                    .toString() +
                    "일 전",
                style: Theme.of(context).textTheme.subtitle2,
              )
                  : Text('-'),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: type == 0
                  ? _userViewModel.user.value.isRefShelf == value
                  ? MangoBlack
                  : MangoDisabledColor
                  : type == 1
                  ? _userViewModel.user.value.isFroShelf == value
                  ? MangoBlack
                  : MangoDisabledColor
                  : _userViewModel.user.value.isRTShelf == value
                  ? MangoBlack
                  : MangoDisabledColor,
              size: 18.0,
            )
          ],
        ));
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
                      Get.back();
                    },
                    child: CupertinoPicker(
                      itemExtent: 32,
                      onSelectedItemChanged: (int newValue) {
                        print(newValue);
                        setState(() {
                          type == 0
                              ? _userViewModel.refAlarm = newValue + 1
                              : type == 1
                                  ? _userViewModel.frozenAlarm = newValue + 1
                                  : _userViewModel.roomTempAlarm = newValue + 1;
                        });
                      },
                      children: List<Widget>.generate(60, (int index) {
                        return Text(
                          (++index).toString(),
                          style: Theme.of(context).textTheme.headline5,
                        );
                      }),
                      scrollController: FixedExtentScrollController(
                          initialItem: type == 0
                              ? _userViewModel.user.value.refrigerationAlarm - 1
                              : type == 1
                                  ? _userViewModel.user.value.frozenAlarm - 1
                                  : _userViewModel.user.value.roomTempAlarm -
                                      1),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
