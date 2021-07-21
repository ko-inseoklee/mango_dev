import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/trade/Chat/chatDetail.dart';
import 'package:mangodevelopment/view/widget/dialog/imageSelectCard.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

class MangoPostCard extends StatelessWidget {
  final FirebaseFirestore mango_dev = FirebaseFirestore.instance;

  // 게시글 관련 정보
  String postID;
  int state;
  DateTime createSince;
  String subtitle;

  // 게시글에 올린 음식 관련 정보
  String foodName;
  int num;
  DateTime shelfLife;

  // 게시글 작성자 관련 정보
  String owner;
  String userName;
  String profileImageRef;


  MangoPostCard(
      {Key? key,
      required String postID,
      required int state,
      required String foodName,
      required String owner,
      required String profileImageRef,
      required DateTime createTime,
      required String subtitle,
      required int num,
      required DateTime shelfLife,
      required userName})
      : postID = postID,
        state = state,
        foodName = foodName,
        owner = owner,
        profileImageRef = profileImageRef,
        createSince = DateTime.now(),
        // DateTime.now().subtract(Duration(
        //     days: createTime.day,
        //     hours: createTime.hour,
        //     minutes: createTime.minute)),
        subtitle = subtitle,
        num = num,
        shelfLife = shelfLife,
        userName = userName;


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
                              // mango_dev.collection('chatRooms').doc().set({
                              //   'user': [
                              //     userName,
                              //     userViewModelController.user.value.userName
                              //   ],
                              //   'postID': postID
                              // });
                              Get.to(ChatDetailPage(), arguments: [
                                postID,
                                state,
                                owner,
                                foodName,
                                num,
                                subtitle,
                                shelfLife,
                                userName,
                              ]);
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
