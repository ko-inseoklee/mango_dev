import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/helpers/show_date_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mangodevelopment/app.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/view/widget/dialog/deleteDialog.dart';
import 'package:mangodevelopment/view/widget/mangoDivider.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';
import 'package:mangodevelopment/widgetController/categoryController.dart';

import '../../../color.dart';

class DetailDialog extends StatefulWidget {
  VoidCallback onPressed;
  final Food food;
  DetailDialog({Key? key, required this.onPressed, required this.food})
      : super(key: key);

  @override
  _DetailDialogState createState() => _DetailDialogState();
}

class _DetailDialogState extends State<DetailDialog> {
  late UserViewModel _user;
  late RefrigeratorViewModel _refController;

  late Food tempFood;
  late DateTime sDay;
  late DateTime rDay;

  int bottomPageIdx = 0;

  late PageController _pageController;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user = Get.find<UserViewModel>();
    _refController = Get.find<RefrigeratorViewModel>();

    tempFood = new Food(
      registrationDay: widget.food.registrationDay,
      fId: widget.food.fId,
      cardStatus: widget.food.cardStatus,
      shelfLife: widget.food.shelfLife,
      displayType: widget.food.displayType,
      rId: widget.food.rId,
      name: widget.food.name,
      index: widget.food.idx,
      method: widget.food.method,
      alarmDate: widget.food.alarmDay,
      status: widget.food.status,
      category: widget.food.category,
      num: widget.food.number,
    );

    sDay = tempFood.shelfLife;
    rDay = tempFood.registrationDay;

    _textEditingController = new TextEditingController(text: tempFood.name);

    _pageController = new PageController(initialPage: bottomPageIdx);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), ScreenUtil().setHeight(16), ScreenUtil().setWidth(20), ScreenUtil().setHeight(16)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text('품목 상세 정보'),
      titlePadding: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(20), ScreenUtil().setHeight(18), 0, 0),
      contentPadding: EdgeInsets.zero,
      content: Container(
          width: ScreenUtil().setWidth(500),
          height: ScreenUtil().setHeight(700),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: ScreenUtil().setHeight(185),
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(15), ScreenUtil().setHeight(8), ScreenUtil().setWidth(5), 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin:
                          EdgeInsets.only(bottom: ScreenUtil().setHeight(8.0)),
                      width: ScreenUtil().setWidth(53),
                      height: ScreenUtil().setHeight(24),
                      child: Text(
                        '기본정보',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(color: MangoDisabledColorDark),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          width: ScreenUtil().setWidth(95),
                          height: ScreenUtil().setHeight(105),
                          child: Container(
                            decoration: BoxDecoration(
                                color: MangoWhite,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: Orange400)),
                            child: Image.asset(
                              'images/category/${categoryImg[translateToKo(tempFood.category)]}',
                              scale: 0.8,
                            ),
                          ),
                        ),
                        Container(
                          width: ScreenUtil().setWidth(160),
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Container(
                                  width: ScreenUtil().setWidth(140),
                                  height: ScreenUtil().setHeight(45),
                                  padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                                  margin: EdgeInsets.only(bottom: 5.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: MangoDisabledColorLight),
                                      borderRadius: BorderRadius.circular(10)),
                                  alignment: Alignment.center,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(2.0, 0, 2.0, 0),
                                        alignment: Alignment.center,
                                        width: ScreenUtil().setWidth(40),
                                        child: Text(
                                          '품명',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2!
                                              .copyWith(
                                                  color: MangoDisabledColor,
                                                  fontSize: 12),
                                        ),
                                      ),
                                      Container(
                                        width: ScreenUtil().setWidth(67),
                                        decoration: BoxDecoration(),
                                        child: TextFormField(
                                          controller: _textEditingController,
                                          textAlign: TextAlign.center,
                                          textInputAction: TextInputAction.next,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                              .copyWith(fontSize: 14.0),
                                          onChanged: (value) {
                                            setState(() {
                                              tempFood.name = value;
                                            });
                                          },
                                          onEditingComplete: () {
                                            FocusScope.of(context).unfocus();
                                          },
                                        ),
                                      ),
                                      Container(
                                        width: ScreenUtil().setWidth(23),
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              tempFood.name = '-';
                                              _textEditingController.text =
                                                  tempFood.name;
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
                                  width: ScreenUtil().setWidth(140),
                                  height: ScreenUtil().setHeight(45),
                                  padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                                  margin: EdgeInsets.only(bottom: 5.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: MangoDisabledColorLight),
                                      borderRadius: BorderRadius.circular(10)),
                                  alignment: Alignment.center,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                                        alignment: Alignment.center,
                                        width: ScreenUtil().setWidth(40),
                                        child: Text(
                                          '수량',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2!
                                              .copyWith(
                                                  color: MangoDisabledColor,
                                                  fontSize: 12.0),
                                        ),
                                      ),
                                      Container(
                                          alignment: Alignment.center,
                                          width: ScreenUtil().setWidth(60),
                                          decoration: BoxDecoration(),
                                          child: Text(
                                            tempFood.number.toString(),
                                            style: TextStyle(fontSize: 12.0),
                                          )),
                                      Container(
                                        width: 25,
                                        child: TextButton(
                                          onPressed: () {
                                            showNumBSheet(idx: tempFood.idx);
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
                                  width: ScreenUtil().setWidth(140),
                                  height: ScreenUtil().setHeight(40),
                                  padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: MangoDisabledColorLight),
                                      borderRadius: BorderRadius.circular(10)),
                                  alignment: Alignment.center,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                                        alignment: Alignment.center,
                                        width: ScreenUtil().setWidth(50),
                                        child: Text(
                                          '카테고리',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2!
                                              .copyWith(
                                                  color: MangoDisabledColor,
                                                  fontSize:
                                                      ScreenUtil().setSp(10)),
                                        ),
                                      ),
                                      Container(
                                          alignment: Alignment.center,
                                          width: ScreenUtil().setWidth(55),
                                          decoration: BoxDecoration(),
                                          child: Text(
                                            tempFood.category,
                                            style: TextStyle(fontSize: 10.0),
                                          )),
                                      Container(
                                        width: ScreenUtil().setWidth(25),
                                        child: TextButton(
                                          onPressed: () {
                                            showCategoryBSheet(tempFood.idx);
                                          },
                                          child: Icon(
                                            Icons.arrow_drop_down,
                                            size: 16,
                                            color: MangoDisabledColorDark,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: MangoDisabledColorLight.withOpacity(0.4),
                    border: Border.all(color: MangoDisabledColorLight)),
                height: ScreenUtil().setHeight(16),
              ),
              Container(
                height: ScreenUtil().setHeight(390),
                child: Column(
                  children: [
                    Container(
                      height: ScreenUtil().setHeight(370),
                      child: PageView(
                        onPageChanged: (value) {
                          setState(() {
                            bottomPageIdx = value;
                          });
                        },
                        controller: _pageController,
                        scrollDirection: Axis.horizontal,
                        children: [canModifyInfoPage(), additionalInfoPage()],
                      ),
                    ),
                    Container(
                        height: ScreenUtil().setHeight(20),
                        child: slider(idx: bottomPageIdx))
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      width: ScreenUtil().setWidth(130),
                      height: ScreenUtil().setHeight(45),
                      decoration: BoxDecoration(
                          color: MangoDisabledColorLight,
                          borderRadius: BorderRadius.circular(5.0)),
                      child: TextButton(
                          onPressed: () => Get.back(),
                          child: Text(
                            '취소',
                            style: TextStyle(color: MangoBlack),
                          ))),
                  Container(
                      width: ScreenUtil().setWidth(130),
                      height: ScreenUtil().setHeight(45),
                      decoration: BoxDecoration(
                          color: Orange400,
                          borderRadius: BorderRadius.circular(5.0)),
                      child: TextButton(
                          onPressed: () async {
                            tempFood.cardStatus = setCardStatus(tempFood);
                            await _refController
                                .updateFood(food: tempFood)
                                .then((value) => Get.back());
                          },
                          child: Text(
                            '저장',
                            style: TextStyle(color: MangoBlack),
                          ))),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(12),
              )
            ],
          )),
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
                              child: Text(
                                (index + 1).toString(),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                tempFood.number = index;
                                Get.back();
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
            tempFood.category = category;
            Get.back();
          });
        },
      ),
    );
  }

  Widget slider({required int idx}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
          2,
          (index) => Icon(
                Icons.fiber_manual_record,
                color: index == idx ? Orange400 : MangoDisabledColor,
                size: ScreenUtil().setSp(16),
              )),
    );
  }

  Widget canModifyInfoPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(ScreenUtil().setSp(15)),
          child: Text(
            '보관방법',
            style: TextStyle(
                color: MangoDisabledColorDark,
                fontSize: ScreenUtil().setSp(14)),
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(16),
                    ScreenUtil().setHeight(8.0),
                    0,
                    ScreenUtil().setHeight(8.0)),
                height: ScreenUtil().setHeight(50),
                width: ScreenUtil().setWidth(265) / 3,
                decoration: BoxDecoration(
                    color: tempFood.method == 0
                        ? MangoWhite
                        : MangoDisabledColorLight.withOpacity(0.7),
                    border: Border.all(
                        color: tempFood.method == 0
                            ? Orange400
                            : MangoDisabledColorLight),
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(10))),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      tempFood.method = 0;
                    });
                  },
                  child: Text(
                    '냉장',
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: tempFood.method == 0
                            ? Orange400
                            : MangoDisabledColorDark),
                  ),
                ),
              ),
              Container(
                height: ScreenUtil().setHeight(50),
                width: ScreenUtil().setWidth(265) / 3,
                decoration: BoxDecoration(
                    color: tempFood.method == 1
                        ? MangoWhite
                        : MangoDisabledColorLight.withOpacity(0.7),
                    border: Border.all(
                        color: tempFood.method == 1
                            ? Orange400
                            : MangoDisabledColorLight)),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      tempFood.method = 1;
                    });
                  },
                  child: Text(
                    '냉동',
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: tempFood.method == 1
                            ? Orange400
                            : MangoDisabledColorDark),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                  0,
                  ScreenUtil().setHeight(8.0),
                  ScreenUtil().setWidth(16.0),
                  ScreenUtil().setHeight(8.0),
                ),
                height: ScreenUtil().setHeight(50),
                width: ScreenUtil().setWidth(265) / 3,
                decoration: BoxDecoration(
                    color: tempFood.method == 2
                        ? MangoWhite
                        : MangoDisabledColorLight.withOpacity(0.7),
                    border: Border.all(
                        color: tempFood.method == 2
                            ? Orange400
                            : MangoDisabledColorLight),
                    borderRadius:
                        BorderRadius.horizontal(right: Radius.circular(10))),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      tempFood.method = 2;
                    });
                  },
                  child: Text(
                    '실온',
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: tempFood.method == 2
                            ? Orange400
                            : MangoDisabledColorDark),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(ScreenUtil().setSp(15)),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: MangoDisabledColorLight))),
              child: Text('표시기준',
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: MangoDisabledColorDark,
                        fontSize: ScreenUtil().setSp(14),
                      )),
            ),
            Spacer(),
            TextButton(
              onPressed: () {
                setState(() {
                  tempFood.displayType = true;
                });
              },
              child: Row(children: [
                Icon(
                  tempFood.displayType
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: tempFood.displayType ? Orange400 : MangoDisabledColor,
                  size: ScreenUtil().setSp(20),
                ),
                SizedBox(
                  width: 2.0,
                ),
                Text(
                  '유통기한',
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontSize: ScreenUtil().setSp(14),
                      color: tempFood.displayType
                          ? Orange400
                          : MangoDisabledColor),
                )
              ]),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  tempFood.displayType = false;
                });
              },
              child: Row(children: [
                Icon(
                    !tempFood.displayType
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color:
                        !tempFood.displayType ? Orange400 : MangoDisabledColor,
                    size: ScreenUtil().setSp(20)),
                SizedBox(
                  width: 2.0,
                ),
                Text('구매일',
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: !tempFood.displayType
                            ? Orange400
                            : MangoDisabledColor,
                        fontSize: ScreenUtil().setSp(14)))
              ]),
            ),
            Container(
              width: ScreenUtil().setWidth(8),
            )
          ],
        ),
        Container(
          margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), 0,
              ScreenUtil().setWidth(20), ScreenUtil().setHeight(20)),
          height: ScreenUtil().setHeight(50),
          decoration: BoxDecoration(
              border: Border.all(color: MangoDisabledColorLight),
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  tempFood.displayType ? '유통기한' : "구매일",
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(14),
                      color: MangoDisabledColorDark),
                ),
              ),
              Spacer(),
              Text(
                tempFood.displayType
                    ? DateFormat.yMd().format(tempFood.shelfLife)
                    : DateFormat.yMd().format(tempFood.registrationDay),
                style: TextStyle(fontSize: ScreenUtil().setSp(16)),
              ),
              TextButton(
                onPressed: () {
                  showMaterialDatePicker(
                      context: context,
                      title: tempFood.displayType ? '유통기한 설정' : "구매일 설정",
                      firstDate: DateTime.now().subtract(Duration(days: 180)),
                      lastDate: DateTime.now().add(Duration(days: 1830)),
                      selectedDate: tempFood.displayType ? sDay : rDay,
                      onChanged: (value) {
                        setState(() {
                          if (tempFood.displayType) {
                            sDay = value;
                            tempFood.shelfLife = sDay;
                          } else {
                            rDay = value;
                            tempFood.registrationDay = rDay;
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
          width: ScreenUtil().setWidth(352),
          alignment: Alignment.centerLeft,
          decoration:
              BoxDecoration(border: Border.all(color: MangoDisabledColorLight)),
          padding: EdgeInsets.fromLTRB(ScreenUtil().setSp(8), 0, 0, 0),
          child: TextButton(
              onPressed: () {
                Get.dialog(DeleteDialog(
                  onPressed: () async {
                    await _refController
                        .deleteFood(fID: widget.food.fId)
                        .then((value) {
                      Get.back();
                      Get.back();
                    });
                  },
                  deleteAll: false,
                  food: widget.food,
                ));
              },
              child: Text(
                '품목 삭제',
                style:
                    TextStyle(color: Red500, fontSize: ScreenUtil().setSp(14)),
              )),
        ),
      ],
    );
  }

  Widget additionalInfoPage() {
    return Container(
      padding: EdgeInsets.all(ScreenUtil().setSp(8)),
      child: Text(
        '영양정보',
        style: TextStyle(
            color: MangoDisabledColorDark, fontSize: ScreenUtil().setSp(14)),
      ),
    );
  }

  int setCardStatus(Food element) {
    int standard = -1;

    print('유통기한 == ${!element.displayType}');

    if (!element.displayType) {
      switch (element.method) {
        case 1:
          standard = _user.user.value.frozenAlarm;
          break;
        case 2:
          standard = _user.user.value.roomTempAlarm;
          break;
        default:
          standard = _user.user.value.refrigerationAlarm;
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
