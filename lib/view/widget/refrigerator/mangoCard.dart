import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/view/market/post/addPost.dart';
import 'package:mangodevelopment/view/widget/dialog/deleteDialog.dart';
import 'package:mangodevelopment/view/widget/dialog/detailDialog.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';
import 'package:mangodevelopment/widgetController/categoryController.dart';

import '../../../color.dart';

class MangoCard extends StatefulWidget {
  final Food food;
  VoidCallback longPressed;
  final bool isLongPressed;
  final bool isPost;


  MangoCard(
      {Key? key,
      required this.food,
      required this.longPressed,
      required this.isLongPressed,
      required this.isPost})
      : super(key: key);

  @override
  _MangoCardState createState() => _MangoCardState();
}

class _MangoCardState extends State<MangoCard> {
  late RefrigeratorViewModel _refController;

  @override
  Widget build(BuildContext context) {
    _refController = Get.find<RefrigeratorViewModel>();

    return whichCard(type: widget.food.cardStatus);
  }

  Widget whichCard({required int type}) {
    switch (type) {
      case 1:
        return overCard();
      case 2:
        return dDayCard();
      case 3:
        return staleCard();
      default:
        return normalCard();
    }
  }

  Widget staleCard() {
    return Stack(children: [
      TextButton(
        onLongPress: widget.longPressed,
        onPressed: onPressed(food: widget.food),
        child: Container(
          width: ScreenUtil().setWidth(108),
          height: ScreenUtil().setHeight(129),
          child: Card(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: MangoDisabledColorLight),
                borderRadius: BorderRadius.circular(10)),
            color: Purple100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  // padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    categories.contains(widget.food.category) ? 'images/category/${categoryImg[translateToKo(widget.food.category)]}' : 'images/category/etc.png',
                    scale: 1.0,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(8.0, 0.0, 0, 0),
                  child: Text(
                    widget.food.name,
                    style: TextStyle(fontSize: ScreenUtil().setSp(15),),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left:8),
                  child: Flexible(
                    child: Text(
                        '${DateFormat.yMd().format(widget.food.registrationDay)}일 등록',
                        style: TextStyle(
                            color: Purple500, fontSize: ScreenUtil().setSp(12)),
                    overflow: TextOverflow.ellipsis,),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      Positioned(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Purple200, borderRadius: BorderRadius.circular(5.0)),
          width: ScreenUtil().setWidth(62),
          height: ScreenUtil().setHeight(24),
          child: Text(
            'STALE',
            style: TextStyle(
                fontWeight: FontWeight.w700, color: Purple500, fontSize: ScreenUtil().setSp(18),),
          ),
        ),
        top: 20,
        left: 20,
      ),
      deleteButton()
    ]);
  }

  Widget overCard() {
    return Stack(children: [
      TextButton(
        onLongPress: widget.longPressed,
        onPressed: onPressed(food: widget.food),
        child: Card(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: MangoDisabledColorLight),
              borderRadius: BorderRadius.circular(10)),
          color: Red50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  categories.contains(widget.food.category) ? 'images/category/${categoryImg[translateToKo(widget.food.category)]}' : 'images/category/etc.png',
                  scale: 1.0,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left:8),
                child: Flexible(
                  child: Text(
                    widget.food.name,
                    style: TextStyle(fontSize: ScreenUtil().setSp(15),),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left:8),
                  child: Text(
                      '${DateTime.now().difference(widget.food.alarmDay).inDays}일 지남',
                      style: TextStyle(color: Red500, fontSize: ScreenUtil().setSp(12),))),
            ],
          ),
        ),
      ),
      Positioned(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Red200, borderRadius: BorderRadius.circular(5.0)),
          width: ScreenUtil().setWidth(44),
          height: ScreenUtil().setHeight(24),
          child: Text(
            'OVER',
            style: TextStyle(
              fontWeight: FontWeight.w700, color: Red500, fontSize: ScreenUtil().setSp(18),),
          ),
        ),
        top: 20,
        left: 20,
      ),
      deleteButton()
    ]);
  }

  Widget dDayCard() {
    return Stack(children: [
      TextButton(
        onLongPress: widget.longPressed,
        onPressed: onPressed(food: widget.food),
        child: Card(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: MangoDisabledColorLight),
              borderRadius: BorderRadius.circular(10)),
          color: Red50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  categories.contains(widget.food.category) ? 'images/category/${categoryImg[translateToKo(widget.food.category)]}' : 'images/category/etc.png',
                  scale: 1.0,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left:8),
                child: Flexible(
                  child: Text(
                    widget.food.name,
                    style: TextStyle(fontSize: ScreenUtil().setSp(15),),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left:8),
                  child: Flexible(
                    child: Text(
                        '${widget.food.shelfLife.difference(DateTime.now()).inDays}일 전',
                        style: TextStyle(color: Red500, fontSize: ScreenUtil().setSp(12),),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
            ],
          ),
        ),
      ),
      Positioned(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Red200, borderRadius: BorderRadius.circular(5.0)),
          width: ScreenUtil().setWidth(44),
          height: ScreenUtil().setHeight(24),
          child: Text(
            'D${widget.food.shelfLife.difference(DateTime.now()).inDays}',
            style: TextStyle(
                fontWeight: FontWeight.w700, color: Red500, fontSize: ScreenUtil().setSp(18),),
          ),
        ),
        top: 20,
        left: 20,
      ),
      deleteButton()
    ]);
  }

  Widget normalCard() {
    return Stack(children: [
      TextButton(
        onLongPress: widget.longPressed,
        onPressed: onPressed(food: widget.food),
        child: Card(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: MangoDisabledColorLight),
              borderRadius: BorderRadius.circular(10)),
          color: MangoWhite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  categories.contains(widget.food.category) ? 'images/category/${categoryImg[translateToKo(widget.food.category)]}' : 'images/category/etc.png',
                  scale: 1.2,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left:8),
                child: Flexible(
                  child: Text(
                    widget.food.name,
                    style: TextStyle(fontSize: ScreenUtil().setSp(15),),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left:8),
                child: widget.food.displayType
                    ? Text(
                        '${widget.food.shelfLife.difference(DateTime.now()).inDays}일 전',
                        style: TextStyle(color: Red500, fontSize: ScreenUtil().setSp(12)))
                    : Text(
                        '${DateFormat.yMd().format(widget.food.registrationDay)}일 등록',
                        style: TextStyle(
                            color: Purple500,
                            fontSize: ScreenUtil().setSp(12))),
              ),
            ],
          ),
        ),
      ),
      deleteButton(),
    ]);
  }

  Widget deleteButton() {
    return widget.isLongPressed
        ? Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: ScreenUtil().setWidth(25),
              height: ScreenUtil().setHeight(25),
              decoration: BoxDecoration(
                  color: Orange700, borderRadius: BorderRadius.circular(25)),
              child: TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                onPressed: () {
                  Get.dialog(DeleteDialog(
                      deleteAll: false,
                      food: widget.food,
                      onPressed: () async {
                        _refController.deleteFood(fID: widget.food.fId).then((value) {
                          Get.back();
                        });
                      }));
                },
                child:  Text(
                  '-',
                  style: TextStyle(
                      color: MangoWhite, fontSize: ScreenUtil().setSp(20)),
                ),
              ),
            ))
        : SizedBox(
            height: 0.1,
          );
  }

  VoidCallback onPressed({required Food food}) {
    return widget.isPost
        ? () {
            Get.to(AddPostPage(
              title: '거래품목 등록',
              food: food,
            ));
          }
        : () {
            Get.dialog(DetailDialog(
                food: food,
                onPressed: () async {
                  _refController
                      .updateFood(food: food)
                      .then((value) => Get.back());
                }));
          };
  }
}
