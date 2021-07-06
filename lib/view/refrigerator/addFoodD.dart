import 'package:flutter/material.dart';
import 'package:mangodevelopment/app.dart';
import 'package:mangodevelopment/view/widget/appBar.dart';

import '../../color.dart';

class AddFoodD extends StatefulWidget {
  final String title;
  const AddFoodD({Key? key, required this.title}) : super(key: key);

  @override
  _AddFoodDState createState() => _AddFoodDState();
}

class _AddFoodDState extends State<AddFoodD> {
  List<TemporaryFood> foods = [];

  int currentIdx = 0;
  int maxIdx = 0;

  TextEditingController _textEditingController =
      new TextEditingController(text: '-');

  @override
  Widget build(BuildContext context) {
    maxIdx = foods.length;
    // foods.clear();
    // currentIdx = 0;
    // maxIdx = 0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MangoWhite,
      appBar: MangoAppBar(
        title: widget.title,
        isLeading: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80 * (deviceHeight / prototypeHeight),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoBody(currentIdx),
                foods.length > 1
                    ? Container(
                        alignment: Alignment.centerLeft,
                        width: deviceWidth,
                        padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                        decoration: BoxDecoration(
                            border: Border.symmetric(
                                horizontal: BorderSide(
                                    color: MangoDisabledColorLight))),
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
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
            height: 70 * (deviceHeight / prototypeHeight),
            width: deviceWidth,
            decoration: BoxDecoration(
                color: Orange400, borderRadius: BorderRadius.circular(10)),
            child: TextButton(
              onPressed: () {
                print('등록완료');
              },
              child: Text(
                '등록',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          )
        ],
      ),
    );
  }

  void addChip() {
    var temp = new TemporaryFood(
        index: maxIdx,
        status: true,
        name: '-',
        num: 0,
        category: '',
        method: 0,
        shelfLife: DateTime.now(),
        registrationDay: DateTime.now());
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
      setFieldValue(currentIdx);
    }
    maxIdx--;

    foods.removeAt(idx);

    for (int i = 0; i < foods.length; i++) {
      foods[i].idx = i;
    }
  }

  void setFieldValue(int idx) {
    _textEditingController.text = foods[idx].name;
  }

  Widget _buildChip({required TemporaryFood food}) {
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
                  borderRadius: BorderRadius.circular(20.0),
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

  List<Widget> _buildChips({required List<TemporaryFood> foods}) {
    return foods.map((e) => _buildChip(food: e)).toList();
  }

  //TODO: parameter has to be changed token of food name.
  Widget InfoBody(int idx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 8.0 * deviceHeight / prototypeHeight,
          decoration: BoxDecoration(
              color: MangoBehindColor,
              border: Border(top: BorderSide(color: MangoDisabledColorLight))),
        ),
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
                            color: MangoDisabledColor,
                            borderRadius: BorderRadius.circular(100)),
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
                                    width: 40 * (deviceWidth / prototypeWidth),
                                    child: Text(
                                      '품명',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(color: MangoDisabledColor),
                                    ),
                                  ),
                                  Container(
                                    width: 120 * deviceWidth / prototypeWidth,
                                    decoration: BoxDecoration(),
                                    child: TextFormField(
                                      controller: _textEditingController,
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                      onChanged: (value) {
                                        setState(() {
                                          foods[idx].name = value;
                                        });
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
                                  )
                                ],
                              ))
                        ],
                      ),
                    )
                  ],
                )
              ],
            )),
        Container(
          padding: EdgeInsets.fromLTRB(
              12 * deviceWidth / prototypeWidth,
              12 * deviceWidth / prototypeWidth,
              0,
              12 * deviceWidth / prototypeWidth),
          child: Text('보관방법'),
        ),
        Container(
          width: deviceWidth,
          padding: EdgeInsets.fromLTRB(
              12 * deviceWidth / prototypeWidth,
              12 * deviceWidth / prototypeWidth,
              0,
              12 * deviceWidth / prototypeWidth),
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: MangoDisabledColorLight))),
          child: Text('표시기준'),
        ),
        Container(
          height: 8.0 * deviceHeight / prototypeHeight,
          decoration: BoxDecoration(color: MangoBehindColor),
        ),
      ],
    );
  }
}

class TemporaryFood {
  int idx;
  bool status;
  String name;
  int number;
  String category;
  int method;
  DateTime shelfLife;
  DateTime registrationDay;

  TemporaryFood(
      {required int index,
      required bool status,
      required String name,
      required int num,
      required String category,
      required int method,
      required DateTime shelfLife,
      required DateTime registrationDay})
      : idx = index,
        status = status,
        name = name,
        number = num,
        category = category,
        method = method,
        shelfLife = shelfLife,
        registrationDay = registrationDay;
  String get getName => name;
}
