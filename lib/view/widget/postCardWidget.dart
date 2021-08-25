import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/model/post.dart';
import 'package:mangodevelopment/view/trade/Chat/chatRoom.dart';
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

  MangoPostCard({Key? key, required Post post}) : post = post;


  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserViewModel>(builder: (userViewModelController) {
      print('HERE!! ${post.owner.profileImageReference} / ${post.postID}');
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
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(calculate(post.registTime.toDate()) + ' 전'),
                    ),
                    Text(
                      post.foods.name + '  ${post.foods.number} 개',
                    ),
                    Text(
                      '유통기한 ${post.foods.shelfLife.year}.${post.foods.shelfLife
                          .month}.${post.foods.shelfLife.day}',
                    ),
                    InkWell(
                      onTap: () {
                        print('check == ${post
                            .owner.userID} / ${userViewModelController
                            .userID}');
                      },
                      child: Text(
                        post.subtitle,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: post.owner.profileImageReference == '-1'
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
                                : Image.network(
                              post.owner.profileImageReference,
                              fit: BoxFit.fitHeight,
                              width: 30,
                              height: 30,
                            ),
                          ),
                          margin: EdgeInsets.only(right: 25),
                        ),
                        Expanded(child: Text(post.owner.userName)),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(20.0)
                            ), border: Border.all(
                            width: 1,
                            color: Colors.grey.withOpacity(0.5),
                          ),),
                          margin: EdgeInsets.only(right: 10),
                          child: post.owner.userID ==
                              userViewModelController.user.value.userID
                              ? Container(
                            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),

                            child: ElevatedButton(
                              child: Icon(Icons.edit),
                              onPressed: () {
                                print('edit');
                              },
                              style: ButtonStyle(
                                  shadowColor: MaterialStateProperty.all<Color>(
                                      Colors.yellow.withOpacity(0.7)),
                                  backgroundColor: MaterialStateProperty.all<
                                      Color>(
                                      Colors.orangeAccent.withOpacity(0.5)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(18.0),
                                          side: BorderSide(
                                              color: Colors.yellow)))),
                            ),
                          ) : Container(
                            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: ElevatedButton(
                              // color: Theme.of(context).accentColor,
                              child: Icon(Icons.send_rounded),
                              onPressed: () {
                                var chatID = post.postID.substring(0, 6) +
                                    userViewModelController.userID
                                        .substring(0, 6);

                                createChatRoom(
                                    chatID,
                                    userViewModelController.userID,
                                    userViewModelController.user.value
                                        .userName);

                                Get.to(ChatRoom(
                                  chatID: chatID,
                                  friendName: post.postID,
                                )
                                );
                              },
                              style: ButtonStyle(
                                  shadowColor: MaterialStateProperty.all<Color>(
                                      Colors.yellow.withOpacity(0.7)),
                                  backgroundColor: MaterialStateProperty.all<
                                      Color>(
                                      Colors.orangeAccent.withOpacity(0.5)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(18.0),
                                          side:
                                          BorderSide(color: Colors.yellow)))),
                            ),
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
    // print('chatID: $chatID');
    mango_dev.collection('chatRooms').doc(chatID).set({
      'chatID': chatID,
      'takerID': uid,
      'takerName': name,
      'postID': post.postID,
      'onwerID': post.owner.userID,
      'ownerName': post.owner.userName,
      'lastAccess': Timestamp.now(),
    });

    var check = await mango_dev
        .collection('user')
        .doc(uid)
        .collection('chatList')
        .where('chatID', isEqualTo: chatID)
        .limit(1)
        .get();

    List<DocumentSnapshot> documents = check.docs;

    if (documents.length > 0) {
      return;
    } else {
      // create docs
      mango_dev.collection('user').doc(uid).collection('chatList').doc().set({
        'chatID': chatID,
        'friend': post.owner.userName,
      });

      mango_dev
          .collection('user')
          .doc(post.owner.userID)
          .collection('chatList')
          .doc()
          .set({
        'chatID': chatID,
        'friend': name,
      });

      // add to user field array 'chats'
      mango_dev.collection('user').doc(uid).update({
        'chats': FieldValue.arrayUnion([chatID]),
      });

      mango_dev
          .collection('user')
          .doc(post.owner.userID).update({
        'chats': FieldValue.arrayUnion([chatID]),
      });
    }
  }
}
