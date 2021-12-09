import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/model/post.dart';
import 'package:mangodevelopment/view/trade/Chat/chatRoom.dart';
import 'package:mangodevelopment/view/trade/editPost.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';
import 'package:mangodevelopment/widgetController/categoryController.dart';
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

class MangoPostCard extends StatefulWidget {
  Post post;

  MangoPostCard({Key? key, required Post post}) : post = post;

  @override
  _MangoPostCardState createState() => _MangoPostCardState();
}

class _MangoPostCardState extends State<MangoPostCard> {
  final FirebaseFirestore mango_dev = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserViewModel>(builder: (userViewModelController) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  'images/category/${categoryImg[translateToKo(
                      widget.post.foods.category)]}',
                  scale: 1.0,
                ),
                // child: CircleAvatar(
                //   radius: 45,
                //   backgroundColor: Colors.grey[200],
                // )
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(calculate(widget.post.registTime.toDate()) +
                          ' 전'),
                    ),
                    Text(
                      widget.post.foods.name +
                          '  ${widget.post.foods.number} 개',
                    ),
                    Text(
                      '유통기한 ${widget.post.foods.shelfLife.year}.${widget.post
                          .foods.shelfLife
                          .month}.${widget.post.foods.shelfLife.day}',
                    ),
                    InkWell(
                      onTap: () {
                        print('check == ${widget.post
                            .owner.userID} / ${userViewModelController
                            .userID}');
                      },
                      child: Text(
                        widget.post.subtitle,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: widget.post.owner.profileImageReference ==
                                '-1'
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
                              widget.post.owner.profileImageReference.isEmpty
                                  ? '-1'
                                  : widget.post.owner.profileImageReference,
                              fit: BoxFit.fitHeight,
                              width: 30,
                              height: 30,
                            ),
                          ),
                          margin: EdgeInsets.only(right: 25),
                        ),
                        Expanded(child: Text(widget.post.owner.userName)),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(20.0)
                            ), border: Border.all(
                            width: 1,
                            color: Colors.grey.withOpacity(0.5),
                          ),),
                          margin: EdgeInsets.only(right: 10),
                          child: widget.post.owner.userID ==
                              userViewModelController.user.value.userID
                              ? Container(
                            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),

                            child: ElevatedButton(
                              child: Icon(Icons.edit),
                              onPressed: () async {
                                Get.to(EditPost(
                                    title: '게시글 수정', post: widget.post));
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
                                var chatID = widget.post.postID.substring(
                                    0, 6) +
                                    userViewModelController.userID
                                        .substring(0, 6);

                                createChatRoom(
                                    chatID,
                                    userViewModelController.userID,
                                    userViewModelController.user.value
                                        .userName);

                                mango_dev.collection('post')
                                    .doc(widget.post.postID)
                                    .update(
                                    {
                                      'chatList': FieldValue.arrayUnion(
                                          [chatID]),
                                    });

                                Get.to(ChatRoom(
                                  chatID: chatID,
                                  friendName: widget.post.owner.userID,
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
      // 'takerName': name,
      'postID': widget.post.postID,
      'ownerID': widget.post.owner.userID,
      // 'ownerName': post.owner.userName,
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
      mango_dev.collection('user').doc(uid).collection('chatList')
          .doc(chatID)
          .set({
        'chatID': chatID,
        'friend': widget.post.owner.userID,
        // 'friend': post.owner.userName,
      });

      mango_dev
          .collection('user')
          .doc(widget.post.owner.userID)
          .collection('chatList')
          .doc(chatID)
          .set({
        'chatID': chatID,
        'friend': uid,
      });

      // add to user field array 'chats'
      mango_dev.collection('user').doc(uid).update({
        'chats': FieldValue.arrayUnion([chatID]),
      });

      mango_dev
          .collection('user')
          .doc(widget.post.owner.userID).update({
        'chats': FieldValue.arrayUnion([chatID]),
      });
    }
  }
}
