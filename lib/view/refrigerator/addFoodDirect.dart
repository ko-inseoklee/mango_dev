import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:mangodevelopment/color.dart';
import 'package:mangodevelopment/view/widget/appBar.dart';
import 'package:mangodevelopment/view/widget/chip.dart';

import '../../app.dart';

enum method { shelf, regist }

class AddFoodDirectPage extends StatefulWidget {
  final String title;
  const AddFoodDirectPage({Key? key, required this.title}) : super(key: key);

  @override
  _AddFoodDirectPageState createState() => _AddFoodDirectPageState();
}

class _AddFoodDirectPageState extends State<AddFoodDirectPage> {
  TextEditingController _nameController = new TextEditingController();

  method _method = method.shelf;

  List<Widget> _chips = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MangoWhite,
      appBar: MangoAppBar(
        isLeading: true,
        key: widget.key,
        title: widget.title,
      ),
      body: Column(
        children: [
          Container(
            height: 62 * (deviceHeight / prototypeHeight),
            child: Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.all(10 * (deviceHeight / prototypeHeight)),
                  child: ActionChip(
                    backgroundColor: Orange50,
                    label: Icon(
                      Icons.add,
                      color: Orange400,
                      size: 16.0,
                    ),
                    onPressed: () {
                      setState(() {
                        addChips();
                      });
                    },
                  ),
                ),
                Expanded(
                    child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _chips,
                ))
              ],
            ),
          ),
          Container(
            height: 7 * (deviceHeight / prototypeHeight),
            color: MangoBehindColor,
          ),
          Container(
            height: 300 * (deviceHeight / prototypeHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.fromLTRB(
                        10 * (deviceHeight / prototypeHeight),
                        8 * (deviceHeight / prototypeHeight),
                        0,
                        8 * (deviceHeight / prototypeHeight)),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '기본 정보',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(color: MangoDisabledColorDark),
                    )),
                Row(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.all(8.0 * deviceWidth / prototypeWidth),
                      decoration: BoxDecoration(
                          border: Border.all(color: MangoDisabledColorLight),
                          borderRadius: BorderRadius.circular(5.0)),
                      height: 200 * (deviceHeight / prototypeHeight),
                      width: 150 * deviceWidth / prototypeWidth,
                    ),
                    Column(
                      children: [
                        AddFoodTextForm(
                          controller: _nameController,
                          title: '품명',
                        ),
                        AddFoodTextForm(
                          controller: _nameController,
                          title: '수량',
                        ),
                        AddFoodTextForm(
                          controller: _nameController,
                          title: '카테고리',
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            height: 7 * (deviceHeight / prototypeHeight),
            color: MangoBehindColor,
          ),
          Expanded(
              child: Column(
            children: [
              Container(
                  padding: EdgeInsets.fromLTRB(
                      10 * (deviceHeight / prototypeHeight),
                      8 * (deviceHeight / prototypeHeight),
                      0,
                      16 * (deviceHeight / prototypeHeight)),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '보관 방법',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(color: MangoDisabledColorDark),
                  )),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: MangoDisabledColorLight),
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(5.0))),
                      width: 110 * deviceWidth / prototypeWidth,
                      height: 55 * (deviceHeight / prototypeHeight),
                      child: TextButton(
                        child: Text('냉장'),
                        onPressed: () => print('good'),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: MangoDisabledColorLight)),
                      width: 110 * deviceWidth / prototypeWidth,
                      height: 55 * (deviceHeight / prototypeHeight),
                      child: TextButton(
                        child: Text('냉동'),
                        onPressed: () => print('good'),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: MangoDisabledColorLight),
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(5.0))),
                      width: 110 * deviceWidth / prototypeWidth,
                      height: 55 * (deviceHeight / prototypeHeight),
                      child: TextButton(
                        child: Text('실온'),
                        onPressed: () => print('good'),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(
                          10 * (deviceHeight / prototypeHeight),
                          16 * (deviceHeight / prototypeHeight),
                          0,
                          16 * (deviceHeight / prototypeHeight)),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '표시 기준',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(color: MangoDisabledColorDark),
                      )),
                  Spacer(),
                  Radio(
                      value: method.shelf,
                      groupValue: _method,
                      onChanged: (value) {
                        setState(() {
                          _method = method.shelf;
                        });
                      }),
                  Text('유통기한'),
                  Radio(
                      value: method.regist,
                      groupValue: _method,
                      onChanged: (value) {
                        setState(() {
                          _method = method.regist;
                        });
                      }),
                  Container(
                      padding: EdgeInsets.only(
                          right: 25 * (deviceWidth / prototypeWidth)),
                      child: Text('구매일')),
                ],
              ),
              AddFoodTextForm(
                controller: _nameController,
                title: '유통기한',
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                    color: Orange400,
                    border: Border.all(color: MangoWhite),
                    borderRadius: BorderRadius.circular(10.0)),
                width: 330 * deviceWidth / prototypeWidth,
                height: 55 * (deviceHeight / prototypeHeight),
                child: TextButton(
                  child: Text(
                    '등록',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: MangoBlack),
                  ),
                  onPressed: () => print('good'),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }

  void addChips() {
    _chips.insert(
        0,
        MangoChip(
            name: '',
            onClick: () {
              print('idx');
            }));
  }

  Widget MangoChip({required String name, required VoidCallback onClick}) {
    return Container(
        padding: EdgeInsets.fromLTRB(6.0, 0, 6.0, 0),
        child: ActionChip(
          label: Text(
            name,
            overflow: TextOverflow.ellipsis,
          ),
          onPressed: onClick,
        ));
  }
}

class AddFoodTextForm extends StatefulWidget {
  final TextEditingController controller;
  final title;
  const AddFoodTextForm({Key? key, required this.controller, this.title})
      : super(key: key);

  @override
  _AddFoodTextFormState createState() => _AddFoodTextFormState();
}

class _AddFoodTextFormState extends State<AddFoodTextForm> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
        padding: EdgeInsets.all(2.0),
        alignment: Alignment.center,
        width: 200 * deviceWidth / prototypeWidth,
        decoration: BoxDecoration(
            border: Border.all(color: MangoDisabledColorLight),
            borderRadius: BorderRadius.circular(5.0)),
        height: 60 * (deviceHeight / prototypeHeight),
        child: Row(
          children: [
            Container(
                padding: EdgeInsets.all(2.0),
                alignment: Alignment.center,
                width: 60,
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: MangoDisabledColorDark,
                      fontWeight: FontWeight.w500),
                )),
            Container(
              width: 80 * (deviceWidth / prototypeWidth),
              height: 37 * (deviceHeight / prototypeHeight),
              child: TextFormField(
                controller: widget.controller,
              ),
            ),
            IconButton(
                onPressed: () => print(widget.controller.text),
                icon: widget.controller.text == ''
                    ? Icon(Icons.add)
                    : Icon(Icons.mail)),
          ],
        ),
      ),
    );
  }
}
