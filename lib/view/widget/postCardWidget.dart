import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/trade/Chat/chatDetail.dart';
import 'package:mangodevelopment/view/widget/dialog/imageSelectCard.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

class MangoPostCard extends StatelessWidget {
  String foodName;
  String owner;
  String profileImageRef;
  DateTime createSince;
  String subtitle;
  int num;
  DateTime shelfLife;

  MangoPostCard(
      {Key? key,
      required String foodName,
      required String owner,
      required String profileImageRef,
      required DateTime createTime,
      required String subtitle,
      required int num,
      required DateTime shelfLife})
      : foodName = foodName,
        owner = owner,
        profileImageRef = profileImageRef,
        createSince = DateTime.now(),
        // DateTime.now().subtract(Duration(
        //     days: createTime.day,
        //     hours: createTime.hour,
        //     minutes: createTime.minute)),
        subtitle = subtitle,
        num = num,
        shelfLife = shelfLife;

  String calculateTime() {
    // print(createTime.toString());
    print(createSince.day.toString() +
        '일 ' +
        createSince.hour.toString() +
        '시간 ' +
        createSince.minute.toString() +
        '분 ');
    if (createSince.day < 1) {
      if (createSince.hour < 1) {
        return createSince.minute.toString() + ' 분 전';
      }
      return createSince.hour.toString() + '시간 전';
    } else {
      return createSince.day.toString() + '일 전';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserViewModel>(builder: (userViewModelController) {
      return Container(
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.grey, width: 1),
        // ),
        // borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircleAvatar(
                    radius: 45,
                    // backgroundImage:
                    backgroundColor: Colors.grey[200],
                  )),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(createSince.month.toString() +
                          '/' +
                          createSince.day.toString()),
                    ),
                    Text(
                      foodName + '  $num개',
                    ),
                    Text(
                      '유통기한 ${shelfLife.year}.${shelfLife.month}.${shelfLife.day}',
                    ),
                    Text(
                      subtitle,
                    ),
                    Row(
                      children: [
                        Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: profileImageRef == '-1'
                                ? Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                            'images/default_profile.png'),
                                      ),
                                    ),
                                  )
                                : Image.file(
                                    File(profileImageRef),
                                    fit: BoxFit.fitHeight,
                                    width: 30,
                                    height: 30,
                                  ),
                          ),
                          margin: EdgeInsets.only(right: 25),
                        ),
                        Container(
                          margin: EdgeInsets.all(5.0),
                          child: ElevatedButton(
                            // color: Orange100,
                            child: Icon(Icons.call),
                            onPressed: () {
                              print('call');
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side:
                                            BorderSide(color: Colors.yellow)))),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5.0),
                          child: ElevatedButton(
                            // color: Theme.of(context).accentColor,
                            child: Icon(Icons.send_rounded),
                            // onPressed: () => showAlertDialog('치즈', 3, '2021.1.30'),
                            onPressed: () {
                              Get.to(ChatDetailPage(), arguments: owner);
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side:
                                            BorderSide(color: Colors.yellow)))),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}