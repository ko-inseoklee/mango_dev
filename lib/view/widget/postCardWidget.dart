import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:mangodevelopment/model/post.dart';
import 'package:mangodevelopment/view/trade/Chat/chatDetail.dart';
import 'package:mangodevelopment/view/trade/Chat/chatRoom.dart';
import 'package:mangodevelopment/view/widget/dialog/imageSelectCard.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';
import 'package:uuid/uuid.dart';

String calculate(DateTime registTime) {
  Duration diff = DateTime.now().difference(registTime);

  if (diff.inDays >= 1) {
    return diff.inDays.toString() + '일';
  } else if (diff.inHours > 1) {
    return diff.inHours.toString() + '시간';
  } else if (diff.inMinutes > 1) {
    return diff.inMinutes.toString() + '분';
  } else {
    return '방금';
  }
}

class MangoPostCard extends StatelessWidget {
  final FirebaseFirestore mango_dev = FirebaseFirestore.instance;

  Post post;

// //  게시글 관련 정보
//   late String postID;
//   late int state; // 0 - 나눔중, 1 - 거래중, 2 - 거래완료
//   late DateTime registTime;
//   late String subtitle;
//
//   // 게시글에 올린 음식 관련 정보
//   late String foodName;
//   late int foodNum;
//   late DateTime shelfLife;
//   late int shelfType; // 0 - 유통기한, 1 - 등록일
//
//   // 게시글 작성자 관련 정보
//   late String ownerID;
//   late String ownerName;
//   late String profileImageRef;

  MangoPostCard({Key? key, required Post post}) : post = post;

  // MangoPostCard(
  //     {Key? key,
  //     required String postID,
  //     required int state,
  //     required String foodName,
  //     required String ownerID,
  //     required String profileImageRef,
  //     required Timestamp registTime,
  //     required String subtitle,
  //     required int foodNum,
  //     required Timestamp shelfLife,
  //     required ownerName})
  //     : postID = postID,
  //       state = state,
  //       foodName = foodName,
  //       ownerID = ownerID,
  //       profileImageRef = profileImageRef,
  //       registTime = registTime.toDate(),
  //       subtitle = subtitle,
  //       foodNum = foodNum,
  //       shelfLife = shelfLife.toDate(),
  //       ownerName = ownerName;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserViewModel>(builder: (userViewModelController) {
      print('HERE!! ${post.profileImageRef} / ${post.postID}');
      return Container(
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
                    // Align(
                    // alignment: Alignment.bottomRight,
                    // child: Text(calculate(post.registTime) + ' 전'),
                    // ),
                    Text(post.ownerName
                        // post.foods.name + '  ${post.foods.number} 개',
                        ),
                    Text(
                      '유통기한 ${post.foods.shelfLife.year}.${post.foods.shelfLife.month}.${post.foods.shelfLife.day}',
                    ),
                    Text(
                      post.subtitle,
                    ),
                    Row(
                      children: [
                        Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: post.profileImageRef == '-1'
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
                                // : Image.network(
                                //   userViewModelController
                                //       .user.value.profileImageReference,
                                //   // width: 90 * deviceWidth / prototypeWidth,
                                //   // height: 90 * deviceWidth / prototypeWidth,
                                //   fit: BoxFit.fitHeight,
                                // )
                                : Image.network(
                                    post.profileImageRef,
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
                            onPressed: () {
                              // var chatID = Uuid().v4().toString();
                              var chatID = post.postID.substring(0, 6) +
                                  userViewModelController.userID
                                      .substring(0, 6);
                              createChatRoom(
                                  chatID,
                                  userViewModelController.userID,
                                  userViewModelController.user.value.userName);
                              Get.to(ChatRoom(
                                chatID: chatID,
                              )
                                  // , arguments: [
                                  // postID,
                                  // state,
                                  // ownerID,
                                  // foodName,
                                  // foodNum,
                                  // subtitle,
                                  // shelfLife,
                                  // ownerName,
                                  // profileImageRef,
                                  // chatID,
                                  // ]
                                  );
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

  void createChatRoom(String chatID, String uid, String name) async {
    mango_dev.collection('chatRooms').doc(chatID).set({
      'chatID': chatID,
      'takerID': uid,
      'takerName': name,
      'postID': post.postID,
      'onwerID': post.ownerID,
      'ownerName': post.ownerName,
    });

    var check = await mango_dev
        .collection('user')
        .doc(uid)
        .collection('chatList')
        .where('chatID', isEqualTo: chatID)
        .limit(1)
        .get();

    List<DocumentSnapshot> documents = check.docs;

    //이미 등록된 친구 일 경우 `snackbar` return
    if (documents.length > 0) {
      return;
    } else {
      mango_dev.collection('user').doc(uid).collection('chatList').doc().set({
        'chatID': chatID,
      });

      mango_dev
          .collection('user')
          .doc(post.ownerID)
          .collection('chatList')
          .doc()
          .set({
        'chatID': chatID,
      });
    }
  }
}
