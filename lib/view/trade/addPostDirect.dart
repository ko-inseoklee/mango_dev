import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mangodevelopment/app.dart';
import 'package:mangodevelopment/model/post.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';
import 'package:mangodevelopment/view/widget/appBar.dart';
import 'package:mangodevelopment/view/widget/dialog/dialog.dart';
import 'package:mangodevelopment/widgetController/categoryController.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';
import 'package:uuid/uuid.dart';

import '../../color.dart';

class AddPostDirectPage extends StatefulWidget {
  final String title;

  const AddPostDirectPage({Key? key, required this.title}) : super(key: key);

  @override
  _AddPostDirectPageState createState() => _AddPostDirectPageState();
}

class _AddPostDirectPageState extends State<AddPostDirectPage> {
  late RefrigeratorViewModel _refrigerator;
  late UserViewModel user;
  final formKey = GlobalKey<FormState>();
  String contentValue = '';
  List<Food> foods = [Food.init()];
  UserViewModel _userViewModel = Get.find<UserViewModel>();

  int currentIdx = 0;
  int maxIdx = 0;

  TextEditingController _textEditingController =
      new TextEditingController(text: '-');

  int tempNum = 0;

  DateTime sDay = DateTime.now();
  DateTime rDay = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _refrigerator = Get.find();

    user = Get.find();

    maxIdx = foods.length;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MangoWhite,
      appBar: MangoAppBar(
        title: widget.title,
        isLeading: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 8.0 * deviceHeight / prototypeHeight,
              decoration: BoxDecoration(
                  color: MangoBehindColor,
                  border:
                      Border(top: BorderSide(color: MangoDisabledColorLight))),
            ),
            Expanded(
              child: foods.length != 0 ? InfoBody(currentIdx) : Text(''),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
              height: ScreenUtil().setHeight(60),
              width: deviceWidth,
              decoration: BoxDecoration(
                  color: Orange400, borderRadius: BorderRadius.circular(10)),
              child: TextButton(
                onPressed: () async {
                  bool isFilled = true;
                  foods.forEach((element) {
                    if (element.name == '-' ||
                        element.category == '-' ||
                        element.number == 0) {
                      isFilled = false;
                    } else {
                      element.cardStatus = setCardStatus(element);
                    }
                  });
                  if (isFilled) {
                    try {
                      await _refrigerator.addFoods(foods).then((value) {
                        formKey.currentState!.validate();
                      });
                    } catch (e) {
                      print('error: $e');
                    }
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return mangoDialog(
                              dialogTitle: '품목 정보 입력',
                              contentText: '정보가 모두 기입되지 않았습니다.',
                              onTapOK: () {},
                              hasOK: false);
                        });
                  }
                },
                child: Text(
                  '등록',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void setFieldValue(int idx) {
    _textEditingController.text = foods[idx].name;
  }

  //TODO: parameter has to be changed token of food name.
  Widget InfoBody(int idx) {
    return ListView(
      children: [
        Container(
            width: deviceWidth,
            padding: EdgeInsets.fromLTRB(
                12 * deviceWidth / prototypeWidth,
                12 * deviceWidth / prototypeWidth,
                0,
                12 * deviceWidth / prototypeWidth),
            decoration: BoxDecoration(
                border:
                    Border(top: BorderSide(color: MangoDisabledColorLight))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '기본정보',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: MangoDisabledColor),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      width: 140 * (deviceWidth / prototypeWidth),
                      height: 140 * (deviceWidth / prototypeWidth),
                      child: Container(
                        decoration: BoxDecoration(
                            color: foods[currentIdx].category == '-'
                                ? MangoDisabledColorLight
                                : MangoWhite,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                color: foods[currentIdx].category == '-'
                                    ? MangoDisabledColorLight
                                    : Orange400)),
                        child: foods[currentIdx].category == '-'
                            ? Text('')
                            : Image.asset(
                                'images/category/${categoryImg[translateToKo(foods[currentIdx].category)]}',
                                scale: 0.8,
                              ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              width: 200 * (deviceWidth / prototypeWidth),
                              height: 55,
                              padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                              margin: EdgeInsets.only(bottom: 5.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: MangoDisabledColorLight),
                                  borderRadius: BorderRadius.circular(10)),
                              alignment: Alignment.center,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                                    alignment: Alignment.center,
                                    width: 60 * (deviceWidth / prototypeWidth),
                                    child: Text(
                                      '품명',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(color: MangoDisabledColor),
                                    ),
                                  ),
                                  Container(
                                    width: 100 * deviceWidth / prototypeWidth,
                                    decoration: BoxDecoration(),
                                    child: TextFormField(
                                      controller: _textEditingController,
                                      textAlign: TextAlign.center,
                                      // textInputAction: TextInputAction.next,
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                      onChanged: (value) {
                                        setState(() {
                                          foods[idx].name = value;
                                        });
                                      },
                                      onEditingComplete: () {
                                        FocusScope.of(context).unfocus();
                                        showNumBSheet(idx: idx);
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 25,
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          foods[idx].name = '-';
                                          _textEditingController.text =
                                              foods[idx].name;
                                        });
                                      },
                                      child: Icon(
                                        Icons.clear,
                                        size: 16,
                                        color: MangoDisabledColorDark,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                              width: 200 * (deviceWidth / prototypeWidth),
                              height: 55,
                              padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                              margin: EdgeInsets.only(bottom: 5.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: MangoDisabledColorLight),
                                  borderRadius: BorderRadius.circular(10)),
                              alignment: Alignment.center,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                                    alignment: Alignment.center,
                                    width: 60 * (deviceWidth / prototypeWidth),
                                    child: Text(
                                      '수량',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(color: MangoDisabledColor),
                                    ),
                                  ),
                                  Container(
                                      alignment: Alignment.center,
                                      width: 100 * deviceWidth / prototypeWidth,
                                      decoration: BoxDecoration(),
                                      child:
                                          Text(foods[idx].number.toString())),
                                  Container(
                                    width: 25,
                                    child: TextButton(
                                      onPressed: () {
                                        showNumBSheet(idx: idx);
                                      },
                                      child: Icon(
                                        Icons.arrow_drop_down,
                                        size: 16,
                                        color: MangoDisabledColorDark,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                              width: 200 * (deviceWidth / prototypeWidth),
                              height: 55,
                              padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: MangoDisabledColorLight),
                                  borderRadius: BorderRadius.circular(10)),
                              alignment: Alignment.center,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                                    alignment: Alignment.center,
                                    width: 60 * (deviceWidth / prototypeWidth),
                                    child: Text(
                                      '카테고리',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(
                                              color: MangoDisabledColor,
                                              fontSize: ScreenUtil().setSp(12)),
                                    ),
                                  ),
                                  Container(
                                      alignment: Alignment.center,
                                      width: 100 * deviceWidth / prototypeWidth,
                                      decoration: BoxDecoration(),
                                      child: Text(foods[idx].category)),
                                  Container(
                                    width: 25,
                                    child: TextButton(
                                      onPressed: () {
                                        showCategoryBSheet(idx);
                                      },
                                      child: Icon(
                                        Icons.arrow_drop_down,
                                        size: 16,
                                        color: MangoDisabledColorDark,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            )),
        Container(
          padding: EdgeInsets.fromLTRB(
              12 * deviceWidth / prototypeWidth,
              12 * deviceWidth / prototypeWidth,
              0,
              12 * deviceWidth / prototypeWidth),
          child: Text('보관방법',
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: MangoDisabledColor)),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(
                    16.0 * deviceWidth / prototypeWidth,
                    8.0 * deviceWidth / prototypeWidth,
                    0,
                    8.0 * deviceWidth / prototypeWidth),
                height: 60,
                width: deviceWidth / 3 - 20,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: foods[currentIdx].method == 0
                            ? Orange400
                            : MangoDisabledColorLight),
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(10))),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      foods[currentIdx].method = 0;
                    });
                  },
                  child: Text(
                    '냉장',
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: foods[currentIdx].method == 0
                            ? Orange400
                            : MangoBlack),
                  ),
                ),
              ),
              Container(
                height: 60,
                width: deviceWidth / 3 - 20,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: foods[currentIdx].method == 1
                            ? Orange400
                            : MangoDisabledColorLight)),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      foods[currentIdx].method = 1;
                    });
                  },
                  child: Text(
                    '냉동',
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: foods[currentIdx].method == 1
                            ? Orange400
                            : MangoBlack),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                    0,
                    8.0 * deviceWidth / prototypeWidth,
                    16.0 * deviceWidth / prototypeWidth,
                    8.0 * deviceWidth / prototypeWidth),
                height: 60,
                width: deviceWidth / 3 - 20,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: foods[currentIdx].method == 2
                            ? Orange400
                            : MangoDisabledColorLight),
                    borderRadius:
                        BorderRadius.horizontal(right: Radius.circular(10))),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      foods[currentIdx].method = 2;
                    });
                  },
                  child: Text(
                    '실온',
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: foods[currentIdx].method == 2
                            ? Orange400
                            : MangoBlack),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                  12 * deviceWidth / prototypeWidth,
                  12 * deviceWidth / prototypeWidth,
                  0,
                  12 * deviceWidth / prototypeWidth),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: MangoDisabledColorLight))),
              child: Text('표시기준',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: MangoDisabledColor)),
            ),
            Spacer(),
            TextButton(
              onPressed: () {
                setState(() {
                  foods[currentIdx].displayType = true;
                });
              },
              child: Row(children: [
                Icon(
                    foods[currentIdx].displayType
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: foods[currentIdx].displayType
                        ? Orange400
                        : MangoDisabledColor),
                SizedBox(
                  width: 2.0,
                ),
                Text(
                  '유통기한',
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: foods[currentIdx].displayType
                          ? Orange400
                          : MangoDisabledColor),
                )
              ]),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  foods[currentIdx].displayType = false;
                });
              },
              child: Row(children: [
                Icon(
                    !foods[currentIdx].displayType
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: !foods[currentIdx].displayType
                        ? Orange400
                        : MangoDisabledColor),
                SizedBox(
                  width: 2.0,
                ),
                Text('구매일',
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: !foods[currentIdx].displayType
                            ? Orange400
                            : MangoDisabledColor))
              ]),
            ),
            Container(
              width: 8.0 * deviceWidth / prototypeWidth,
            )
          ],
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
          height: 55 * (deviceHeight / prototypeHeight),
          decoration: BoxDecoration(
              border: Border.all(color: MangoDisabledColorLight),
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(foods[currentIdx].displayType ? '유통기한' : "구매일"),
              ),
              Spacer(),
              Text(
                foods[currentIdx].displayType
                    ? DateFormat.yMd().format(foods[currentIdx].shelfLife)
                    : DateFormat.yMd()
                        .format(foods[currentIdx].registrationDay),
              ),
              TextButton(
                onPressed: () {
                  showMaterialDatePicker(
                      context: context,
                      title:
                          foods[currentIdx].displayType ? '유통기한 설정' : "구매일 설정",
                      firstDate: DateTime.now().subtract(Duration(days: 180)),
                      lastDate: DateTime.now().add(Duration(days: 1830)),
                      selectedDate: foods[currentIdx].displayType ? sDay : rDay,
                      onChanged: (value) {
                        setState(() {
                          if (foods[currentIdx].displayType) {
                            sDay = value;
                            foods[currentIdx].shelfLife = sDay;
                          } else {
                            rDay = value;
                            foods[currentIdx].registrationDay = rDay;
                          }
                        });
                      });
                },
                child: Icon(
                  Icons.arrow_drop_down,
                  color: MangoDisabledColor,
                ),
              )
            ],
          ),
        ),
        Container(
          height: 8.0 * deviceHeight / prototypeHeight,
          decoration: BoxDecoration(color: MangoBehindColor),
        ),
        Container(
            alignment: Alignment.center,
            height: ScreenUtil().setHeight(64),
            margin: EdgeInsets.all(ScreenUtil().setSp(16.0)),
            padding: EdgeInsets.only(left: ScreenUtil().setSp(8.0)),
            decoration: BoxDecoration(
                color: MangoBehindColor,
                borderRadius: BorderRadius.circular(10.0)),
            child: Form(
              key: formKey,
              child: TextFormField(
                maxLength: 20,
                validator: (value) {
                  if (value!.isEmpty) {
                    Get.snackbar('등록 오류', '메세지가 입력되지 않았습니다.');
                  } else {
                    contentValue = value;

                    Post _post = Post.init();
                    _post.fid = foods.first.fId;
                    _post.postID = Uuid().v4();
                    _post.state = 0;
                    _post.registTime = Timestamp.now();
                    _post.subtitle = contentValue;
                    _post.foods = foods.first;
                    _post.owner = _userViewModel.user.value; //location 포함
                    _post.chatList = [];
                    _userViewModel.addPost(_post).then((_) {
                      Get.back();
                      Get.back();
                      Get.back();
                    });
                  }
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '남기고 싶은 메세지를 작성해주세요.(최대 20자)'),
              ),
            )),
      ],
    );
  }

  showNumBSheet({required int idx}) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        context: context,
        builder: (context) {
          return Container(
              height: ScreenUtil().setHeight(284),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                        color: MangoDisabledColor,
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Text(
                      '수량',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    height: ScreenUtil().setHeight(160),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Container(
                          height: 25,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(4.0),
                            title: Center(
                              child: Text((index + 1).toString()),
                            ),
                            onTap: () {
                              setState(() {
                                foods[idx].number = index;
                                Get.back();
                                showCategoryBSheet(idx);
                              });
                            },
                          ),
                        );
                      },
                      itemCount: 50,
                    ),
                  )
                ],
              ));
        });
  }

  showCategoryBSheet(int idx) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        context: context,
        builder: (context) {
          return Container(
              height: ScreenUtil().setHeight(350),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                        color: MangoDisabledColor,
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Text(
                      '카테고리',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    height: ScreenUtil().setHeight(250),
                    child: GridView.count(
                        childAspectRatio: 107 / 49,
                        crossAxisCount: 3,
                        children: _buildGridCard()),
                  )
                ],
              ));
        });
  }

  List<Widget> _buildGridCard() {
    return categories.map((e) => _buildCard(category: e)).toList();
  }

  Widget _buildCard({required String category}) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: MangoDisabledColorLight)),
      alignment: Alignment.center,
      child: TextButton(
        child: Text(
          category,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        onPressed: () {
          setState(() {
            foods[currentIdx].category = category;
            Get.back();
          });
        },
      ),
    );
  }

  int setCardStatus(Food element) {
    int standard = -1;

    print('유통기한 == ${!element.displayType}');

    if (!element.displayType) {
      switch (element.method) {
        case 1:
          standard = user.user.value.frozenAlarm;
          break;
        case 2:
          standard = user.user.value.roomTempAlarm;
          break;
        default:
          standard = user.user.value.refrigerationAlarm;
      }
      if (DateTime.now().difference(element.registrationDay).inDays >=
          standard) {
        return 3;
      } else {
        return 0;
      }
    } else {
      int shelf = element.shelfLife.difference(DateTime.now()).inDays;
      print('shelf == $shelf');
      if (shelf <= 0) {
        return 1;
      } else if (shelf <= 7) {
        return 2;
      } else {
        return 0;
      }
    }
  }
}
