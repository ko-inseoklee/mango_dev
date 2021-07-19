import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mangodevelopment/color.dart';
import 'package:mangodevelopment/viewModel/categoryController.dart';
import 'package:mangodevelopment/viewModel/foodViewModel.dart';

class CardWidgets extends GetxController {
  Rx<TemporaryFood> food;

  CardWidgets({required TemporaryFood food}) : food = food.obs;

  Widget selectWidget() {
    if (this.food.value.isModify)
      return Text('isModify');
    else if (this.food.value.shelfOver)
      return Text('shelfOver');
    else if (this.food.value.shelfDDay)
      return Text('shelfDDay');
    else if (this.food.value.shelfNormal)
      return Text('shelfNormal');
    else if (this.food.value.registerAbnormal)
      return Text('registerAbnormal');
    else if (this.food.value.registerNormal)
      return Text('registerNormal');
    else
      return Text('No one');
  }

  // Widget shelfNormal(){
  //   return TextButton(onPressed: onPressed, child: child)
  // }
  //
  Widget _buildFoodCard(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Orange400,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: MangoDisabledColorLight, width: 2.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                    'images/category/${categoryImg[translateToKo(food.category)]}'),
                Container(
                    padding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 6.0),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          food.name,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Spacer(),
                        Text(
                          food.number.toString() + '개',
                          style:
                              Theme.of(context).textTheme.subtitle2!.copyWith(),
                        )
                      ],
                    )),
                Container(
                  padding: EdgeInsets.only(left: 12.0),
                  alignment: Alignment.centerLeft,
                  child: food.displayType
                      ? Text('${DateFormat.yMd().format(food.shelfLife)}일 까지',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Red500, fontSize: 12.0))
                      : Text(
                          '${DateFormat.yMd().format(food.registrationDay)}일 등록',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Purple500, fontSize: 12.0)),
                ),
              ],
            ),
          ),
          Positioned(
            width: 70,
            height: 30,
            child: !food.displayType
                ? food.method == 0
                    ? DateTime.now().difference(food.registrationDay).inDays >
                            registerRef
                        ? Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Purple100,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Purple200)),
                            child: Text(
                              'STALE',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                      color: Purple500,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 22.0),
                            ))
                        : Text('')
                    : food.method == 1
                        ? DateTime.now()
                                    .difference(food.registrationDay)
                                    .inDays >
                                registerFro
                            ? Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Purple100,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Purple200)),
                                child: Text(
                                  'STALE',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                          color: Purple500,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 22.0),
                                ))
                            : Text('')
                        : DateTime.now()
                                    .difference(food.registrationDay)
                                    .inDays >
                                registerRT
                            ? Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Purple100,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Purple200)),
                                child: Text(
                                  'STALE',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                          color: Purple500,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 22.0),
                                ))
                            : Text('')
                : food.shelfLife.difference(DateTime.now()).inDays <= 0
                    ? Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Red200,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Orange700)),
                        child: Text(
                          'OVER',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  color: Red500,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22.0),
                        ))
                    : food.shelfLife.difference(DateTime.now()).inDays <= 7
                        ? Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Red200,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              'D-${food.shelfLife.difference(DateTime.now()).inDays + 1}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                      color: Red500,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 22.0),
                            ),
                          )
                        : Container(),
            left: 5,
            top: 5,
          ),
        ],
      ),
    );
  }
}
