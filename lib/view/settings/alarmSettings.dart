import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangodevelopment/view/widget/dialog/dialog.dart';
import 'package:mangodevelopment/view/widget/setting/settingMenu.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

import '../../app.dart';
import '../../color.dart';
import '../splash.dart';

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

  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('알람 관리'),
        centerTitle: true,
      ),
      backgroundColor: MangoWhite,
      body: Container(
        height: deviceHeight,
        width: deviceWidth,
        child: ListView(children: [
          Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  '알림 설정',
                  style: Theme.of(context).textTheme.caption!.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.0,),
                ),
                padding: EdgeInsets.fromLTRB(
                    15, 20 * deviceWidth / prototypeWidth, 0, 0),
                alignment: Alignment.centerLeft,
              ),
              //TODO: Push Notification 기능 추가
              settingMenu(
                menuName: '푸시 알림 설정',
                onTap: (){},
                trailing: Switch(
                  value: isSwitched,
                  activeColor: Orange400,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                    });
                  },
                ),
                trailingWidth: 60,
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
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                child: isExpanded
                    ? ConstrainedBox(
                  constraints:
                  BoxConstraints(minHeight: 60, maxHeight: ScreenUtil().setHeight(450)),
                  child: Column(children: [
                    Expanded(
                        child: ListView(
                          children: [setAlarm()],
                        ))
                  ]),
                )
                    : SizedBox(
                  height: 0.001,
                ),
              ),

              settingMenu(menuName: '알림음', onTap: () => comingSoon(context), trailing: Text('MANGO'), trailingWidth: 100,)
            ],
          ),
        ]),
      ),
    );
  }

  // Picker picker(BuildContext context) {
  //   Picker picker = Picker(
  //       textAlign: TextAlign.center,
  //       adapter: PickerDataAdapter<int>(pickerdata: dateData()),
  //       changeToFirst: false,
  //       onConfirm: (Picker picker, List value) {
  //         setState(() {
  //           int val = picker.getSelectedValues()[0];
  //           _refrigerationAlarm = val;
  //
  //           print(_refrigerationAlarm);
  //         });
  //       });
  //   return picker;
  // }
  //
  // void showPicker(BuildContext context, Picker picker) {
  //   picker.showModal(this.context);
  // }

  List<int> dateData() {
    List<int> result = [];
    for (int i = 1; i <= 60; i++) {
      result.add(i);
    }

    return result;
  }
}

class setAlarm extends StatefulWidget {
  @override
  setAlarmState createState() => setAlarmState();
}

class setAlarmState extends State<setAlarm> {


  UserViewModel userViewModel = Get.find<UserViewModel>();

  @override
  Widget build(BuildContext context) {
      return Column(children: [
        Container(
            padding: EdgeInsets.fromLTRB(20, 15, 0, 0),
            child: Row(
              children: [
                Text(
                  '실온 제품',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: Orange400, fontWeight: FontWeight.w700),
                ),
              ],
            )),
        settingMenu(
          menuName: '유통기한 기준',
          onTap: () {
            if (!userViewModel.user.value.isRTShelf) {
              userViewModel.isRTShelf = true;
            }
          },
          trailing: FlatButton(
              onPressed: () {
                showMaterialNumberPicker(
                    context: context,
                    minNumber: 1,
                    maxNumber: 60,
                    selectedNumber: userViewModel.user.value.roomTempAlarm,
                    onChanged: (value) {
                      setState(() {
                        userViewModel.roomTempAlarm = value;
                      });
                    });
              },
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 50,
                    child: userViewModel.user.value.isRTShelf
                        ? Text(
                      userViewModel.user.value.roomTempAlarm.toString() + "일 전",
                      style: Theme.of(context).textTheme.subtitle2,
                    )
                        : Text('-'),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: userViewModel.user.value.isRTShelf
                        ? MangoBlack
                        : MangoDisabledColor,
                    size: 18.0,
                  )
                ],
              )),
          trailingWidth: 100,
          isActive: userViewModel.user.value.isRTShelf,
        ),
        settingMenu(
          menuName: '구매일 기준',
          onTap: () {
            if (userViewModel.user.value.isRTShelf) {
              userViewModel.isRTShelf = false;
            }
          },
          trailing: FlatButton(
              onPressed: () {
                showMaterialNumberPicker(
                    context: context,
                    minNumber: 1,
                    maxNumber: 60,
                    selectedNumber: userViewModel.user.value.roomTempAlarm,
                    onChanged: (value) {
                      setState(() {
                        userViewModel.refAlarm = value;
                      });
                    });
              },
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 50,
                    child: !userViewModel.user.value.isRTShelf
                        ? Text(
                      userViewModel.user.value.roomTempAlarm.toString() + "일 후",
                      style: Theme.of(context).textTheme.subtitle2,
                    )
                        : Text('-'),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: !userViewModel.user.value.isRTShelf
                        ? MangoBlack
                        : MangoDisabledColor,
                    size: 18.0,
                  )
                ],
              )),
          trailingWidth: 100,
          isActive: !userViewModel.user.value.isRTShelf,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, 15, 0, 0),
          child: Text(
            '냉장 제품',
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: Orange400, fontWeight: FontWeight.w700),
          ),
          alignment: Alignment.centerLeft,
        ),
        settingMenu(
          menuName: '유통기한 기준',
          onTap: () {
            if (!userViewModel.user.value.isRefShelf) {
              userViewModel.isRTShelf = true;
            }
          },
          isActive: userViewModel.user.value.isRefShelf,
          trailing: FlatButton(
              onPressed: () {
                showMaterialNumberPicker(
                    context: context,
                    minNumber: 1,
                    maxNumber: 60,
                    selectedNumber: userViewModel.user.value.refrigerationAlarm,
                    onChanged: (value) {
                      setState(() {
                        userViewModel.refAlarm = value;
                      });
                    });
              },
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 50,
                    child: userViewModel.user.value.isRefShelf
                        ? Text(
                      userViewModel.user.value.refrigerationAlarm.toString() +
                          "일 전",
                      style: Theme.of(context).textTheme.subtitle2,
                    )
                        : Text('-'),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: userViewModel.user.value.isRefShelf
                        ? MangoBlack
                        : MangoDisabledColor,
                    size: 18.0,
                  )
                ],
              )),
          trailingWidth: 100,
        ),
        settingMenu(
          menuName: '구매일 기준',
          onTap: () {
            if (userViewModel.user.value.isRefShelf) {
               userViewModel.isRefShelf = false;
            }
          },
          isActive: !userViewModel.user.value.isRefShelf,
          trailing: FlatButton(
              onPressed: () {
                showMaterialNumberPicker(
                    context: context,
                    minNumber: 1,
                    maxNumber: 60,
                    selectedNumber: userViewModel.user.value.refrigerationAlarm,
                    onChanged: (value) {
                      setState(() {
                        userViewModel.refAlarm = value;
                      });
                    });
              },
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 50,
                    child: !userViewModel.user.value.isRefShelf
                        ? Text(
                      userViewModel.user.value.refrigerationAlarm.toString() +
                          "일 후",
                      style: Theme.of(context).textTheme.subtitle2,
                    )
                        : Text('-'),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: !userViewModel.user.value.isRefShelf
                        ? MangoBlack
                        : MangoDisabledColor,
                    size: 18.0,
                  )
                ],
              )),
          trailingWidth: 100,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, 15, 0, 0),
          child: Text(
            '냉동 제품',
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: Orange400, fontWeight: FontWeight.w700),
          ),
          alignment: Alignment.centerLeft,
        ),
        settingMenu(
          menuName: '유통기한 기준',
          onTap: () {
            if (!userViewModel.user.value.isFroShelf) {
              userViewModel.isFroShelf = true;
            }
          },
          isActive: userViewModel.user.value.isFroShelf,
          trailing: FlatButton(
              onPressed: () {
                showMaterialNumberPicker(
                    context: context,
                    minNumber: 1,
                    maxNumber: 60,
                    selectedNumber: userViewModel.user.value.frozenAlarm,
                    onChanged: (value) {
                      setState(() {
                        userViewModel.frozenAlarm = value;
                      });
                    });
              },
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 50,
                    child: userViewModel.user.value.isFroShelf
                        ? Text(
                      userViewModel.user.value.frozenAlarm.toString() + "일 전",
                      style: Theme.of(context).textTheme.subtitle2,
                    )
                        : Text('-'),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: userViewModel.user.value.isFroShelf
                        ? MangoBlack
                        : MangoDisabledColor,
                    size: 18.0,
                  )
                ],
              )),
          trailingWidth: 100,
        ),
        settingMenu(
          menuName: '구매일 기준',
          onTap: () {
            if (userViewModel.user.value.isFroShelf) {
              userViewModel.isFroShelf = false;
            }
          },
          isActive: !userViewModel.user.value.isFroShelf,
          trailing: FlatButton(
              onPressed: () {
                showMaterialNumberPicker(
                    context: context,
                    minNumber: 1,
                    maxNumber: 60,
                    selectedNumber: userViewModel.user.value.frozenAlarm,
                    onChanged: (value) {
                      setState(() {
                        userViewModel.frozenAlarm = value;
                      });
                    });
              },
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 50,
                    child: !userViewModel.user.value.isFroShelf
                        ? Text(
                      userViewModel.user.value.frozenAlarm.toString() + "일 후",
                      style: Theme.of(context).textTheme.subtitle2,
                    )
                        : Text('-'),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: !userViewModel.user.value.isFroShelf
                        ? MangoBlack
                        : MangoDisabledColor,
                    size: 18.0,
                  )
                ],
              )),
          trailingWidth: 100,
        ),
      ]);
  }
}