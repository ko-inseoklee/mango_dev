import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mangodevelopment/app.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';
import 'package:mangodevelopment/view/widget/appBar.dart';
import 'package:mangodevelopment/view/widget/dialog/dialog.dart';
import 'package:mangodevelopment/widgetController/categoryController.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';
import 'package:uuid/uuid.dart';

import '../../color.dart';

class AddFoodDirectPage extends StatefulWidget {
  final String title;
  const AddFoodDirectPage({Key? key, required this.title}) : super(key: key);

  @override
  _AddFoodDirectPageState createState() => _AddFoodDirectPageState();
}

class _AddFoodDirectPageState extends State<AddFoodDirectPage> {
  late RefrigeratorViewModel _refrigerator;
  late UserViewModel user;

  List<Food> foods = [Food.init()];

  int currentIdx = 0;
  int maxIdx = 0;

  TextEditingController _textEditingController =
      new TextEditingController(text: '-');

  int tempNum = 0;

  DateTime sDay = DateTime.now();
  DateTime rDay = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _refrigerator = Get.find();

    print('ref id == ${_refrigerator.ref.value.rID}');
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
              height: ScreenUtil().setHeight(67),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                    child: ActionChip(
                        backgroundColor: Orange50,
                        label: Icon(
                          Icons.add,
                          size: 18.0,
                          color: Orange700,
                        ),
                        onPressed: () {
                          setState(() {
                            addChip();
                          });
                        }),
                  ),
                  Expanded(
                      child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _buildChips(foods: foods),
                  ))
                ],
              ),
            ),
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
                      await _refrigerator
                          .addFoods(foods)
                          .then((value) => Get.back());
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

                  //TODO: push refrigerator.
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

  void addChip() {
    var temp = new Food(
        rId: _refrigerator.ref.value.rID,
        fId: Uuid().v4(),
        index: maxIdx,
        status: true,
        name: '-',
        num: 0,
        category: '-',
        method: 0,
        displayType: true,
        shelfLife: DateTime.now(),
        registrationDay: DateTime.now(),
        alarmDate: DateTime.now(),
        cardStatus: -1);
    foods.add(temp);

    currentIdx = maxIdx;
    setFieldValue(currentIdx);
  }

  void clearChip() {
    foods.clear();
    maxIdx = foods.length;
    currentIdx = 0;
  }

  void deleteChip(int idx) {
    if (currentIdx != 0 && foods.length != 0) {
      currentIdx--;
    }
    maxIdx--;

    foods.removeAt(idx);

    for (int i = 0; i < foods.length; i++) {
      foods[i].idx = i;
    }
    setFieldValue(currentIdx);
  }

  void setFieldValue(int idx) {
    _textEditingController.text = foods[idx].name;
  }

  Widget _buildChip({required Food food}) {
    return Stack(
      children: [
        Wrap(
          direction: Axis.vertical,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(
                  4.0 * deviceWidth / prototypeWidth,
                  12.0 * deviceWidth / prototypeWidth,
                  4.0 * deviceWidth / prototypeWidth,
                  12.0 * deviceWidth / prototypeWidth),
              decoration: BoxDecoration(
                  color: currentIdx == food.idx ? MangoWhite : MangoBehindColor,
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(
                      color: currentIdx == food.idx
                          ? Orange700
                          : MangoDisabledColor)),
              child: TextButton(
                child: Text(
                  food.name,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: currentIdx == food.idx ? Orange700 : MangoBlack),
                ),
                onPressed: () {
                  setState(() {
                    currentIdx = food.idx;
                    setFieldValue(currentIdx);
                  });
                },
                onLongPress: () {
                  setState(() {
                    food.status = !food.status;
                  });
                },
              ),
            )
          ],
        ),
        !food.status
            ? Positioned(
                right: 0,
                top: 5,
                child: Wrap(
                  children: [
                    Container(
                        constraints:
                            BoxConstraints(maxWidth: 30, maxHeight: 30),
                        decoration: BoxDecoration(
                            color: MangoWhite,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Orange200)),
                        child: TextButton(
                          child: Icon(
                            Icons.clear,
                            size: 12.0,
                          ),
                          onPressed: () {
                            setState(() {
                              deleteChip(food.idx);
                            });
                          },
                        ))
                  ],
                ))
            : Text(' ')
      ],
    );
  }

  List<Widget> _buildChips({required List<Food> foods}) {
    return foods.map((e) => _buildChip(food: e)).toList();
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
        foods.length > 1
            ? Container(
                alignment: Alignment.centerLeft,
                width: deviceWidth,
                padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                decoration: BoxDecoration(
                    border: Border.symmetric(
                        horizontal:
                            BorderSide(color: MangoDisabledColorLight))),
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        deleteChip(currentIdx);
                      });
                    },
                    child: Text(
                      '품목 삭제',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(color: Red500),
                    )),
              )
            : Text(' '),
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
