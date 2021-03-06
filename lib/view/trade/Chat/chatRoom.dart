import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/widget/dialog/dialog.dart';
import 'package:mangodevelopment/viewModel/chatRoomViewModel.dart';
import 'package:mangodevelopment/viewModel/sendFCM.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

import '../../../color.dart';

class ChatRoom extends StatefulWidget {
  late String chatID;
  late String friendName;

  ChatRoom({Key? key, required String chatID, required String friendName})
      : chatID = chatID,
        friendName = friendName;

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  var _stream;
  late int state = 0;
  late String foodName = '';
  late int foodNum = 0;
  late String subtitle = '';
  late String _state = '';

  String friend = '';

  @override
  void initState() {
    super.initState();

    getName(widget.friendName);

    mango_dev
        .collection('chatRooms')
        .where('chatID', isEqualTo: widget.chatID)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        _stream = element.reference.collection('messages').snapshots();
      });
    });

    // check if the post exit
    mango_dev
        .collection('post')
        .where('chatList', arrayContains: widget.chatID)
        .get()
        .then((value) {
      if (value.docs.length == 0) {
        state = 3;
      } else {
        // print('length = ${value.docs.length}');
        value.docs.forEach((element) {
          setState(() {
            foodName = element.get('foodName');
            foodNum = element.get('foodNum');
            subtitle = element.get('subtitle');
            state = element.get('state');
          });
        });
      }
    });

    ChatRoomViewModel().AccessChatRoom(
        widget.chatID,
        userViewModelController.userID,
        userViewModelController.user.value.userName);
  }

  Future<void> getName(String friendID) async {
    FirebaseFirestore.instance
        .collection('user')
        .doc(friendID)
        .get()
        .then((value) {
      setState(() {
        friend = value.get('userName');
      });
    });
  }

  final FirebaseFirestore mango_dev = FirebaseFirestore.instance;

  TextEditingController messageController = TextEditingController();

  ScrollController scrollController = ScrollController();

  UserViewModel userViewModelController = Get.find<UserViewModel>();

  Future<void> send(
      String chatID, String curr_uid, String currName, String text) async {
    if (text.length > 0) {
      await mango_dev
          .collection('chatRooms')
          .where('chatID', isEqualTo: chatID)
          .get()
          .then((value) {
        value.docs.forEach((element) async {
          mango_dev
              .collection('chatRooms')
              .doc(element.id)
              .collection('messages')
              .add({
            'text': text,
            'from': curr_uid,
            'to': element.get('takerID') == curr_uid
                ? element.get('ownerID')
                : element.get('takerID'),
            'date': Timestamp.now(),
            'read': false,
          });

          var _id = element.get('takerID') == curr_uid
              ? element.get('ownerID')
              : element.get('takerID');

          mango_dev.collection('user').doc(_id).get().then((value) {
            sendMessage(value.get('tokens'), currName, text, chatID);
          });
        });
      });
      messageController.clear();

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 200),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel userViewModelController = Get.find<UserViewModel>();

    // 0: ?????????, 1: ?????????, 2: ????????????
    if (state == 0) {
      setState(() {
        _state = '?????????';
      });
    } else if (state == 1) {
      setState(() {
        _state = '?????? ???';
      });
    } else if (state == 2) {
      setState(() {
        _state = '?????? ??????';
      });
    }
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(friend)
          // title: Text(ownerName + ' ( ' + foodName + foodNum.toString() + '??? )'),
          ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: mango_dev
                      .collection('chatRooms')
                      .doc(widget.chatID)
                      .collection('messages')
                      .orderBy('date')
                      .snapshots(),
                  builder: (context, snapshot) {
                    ChatRoomViewModel().AccessChatRoom(
                        widget.chatID,
                        userViewModelController.userID,
                        userViewModelController.user.value.userName);
                    if (!snapshot.hasData)
                      return Center(
                        child: CircularProgressIndicator(),
                      );

                    List<DocumentSnapshot> docs = snapshot.data!.docs;

                    List messages = docs.map((doc) {
                      return Message(
                        from: doc['from'],
                        // id to name
                        text: doc['text'],
                        to: doc['to'],
                        // id to name
                        me: userViewModelController.userID == doc['from'],
                        read: doc['read'],
                        time: doc['date'],
                      );
                    }).toList();

                    // TODO: check if chat page is null
                    var empty = true;
                    if (docs.length != 0) empty = false;

                    return Stack(
                      children: <Widget>[
                        Container(
                          child: empty
                              ? Center(
                                  child: Text('????????? ????????? ?????????'),
                                )
                              : ListView(
                                  controller: scrollController,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 100,
                                      child:
                                          Image.asset('images/login/logo.png'),
                                    ),
                                    ...messages,
                                    SizedBox(height: 15)
                                  ],
                                ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListTile(
                              //TODO: change to post foodIMG
                              // leading:
                              title: state == 3
                                  ? Text('????????? ?????????')
                                  : Row(
                                      children: [
                                        Text(
                                          _state + ' ',
                                          style: TextStyle(color: Colors.amber),
                                        ),
                                        Text(foodName +
                                            ' ' +
                                            foodNum.toString() +
                                            '???')
                                      ],
                                    ),
                              subtitle:
                                  state == 3 ? Text('(?????? ??????)') : Text(subtitle),
                              trailing: state == 2
                                  ? OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.grey[200]),
                                      onPressed: () => null,
                                      child: Text(
                                        '?????? ??????',
                                        style: TextStyle(color: Colors.grey),
                                      ))
                                  : OutlinedButton(
                                      onPressed: () {
                                        Get.dialog(mangoDialog(
                                          hasOK: true,
                                          dialogTitle: '????????????',
                                          onTapOK: () {
                                            mango_dev
                                                .collection('post')
                                                .where('chatList',
                                                    arrayContains:
                                                        widget.chatID)
                                                .get()
                                                .then((value) {
                                              if (value.docs.length == 0) {
                                                // state = 3;
                                              } else {
                                                value.docs.forEach((element) {
                                                  mango_dev
                                                      .collection('post')
                                                      .doc(element.id)
                                                      .update({
                                                    'state': 2
                                                  }).then((value) {
                                                    setState(() {
                                                      state = 2;
                                                    });
                                                  });
                                                });
                                              }
                                            });

                                            Get.back();
                                          },
                                          contentText: '?????? ????',
                                        ));

                                        //
                                      },
                                      child: Text('????????????'),
                                    ),
                            ),
                          ),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0.5,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ],
                              // border: Border.all(
                              //   color: Colors.grey, // red as border color
                              // ),
                              color: Colors.white),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 60,
                        child: TextField(
                          onSubmitted: (value) => send(
                              widget.chatID,
                              userViewModelController.userID,
                              userViewModelController.user.value.userName,
                              messageController.text),
                          // from who ?
                          decoration: InputDecoration(
                            hintText: 'Enter a Message...',
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                          ),
                          controller: messageController,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        color: messageController.text.isEmpty
                            ? Colors.grey
                            : Colors.orangeAccent,
                      ),
                      onPressed: () {
                        send(
                                widget.chatID, //generate docID by Post
                                userViewModelController.userID,
                                userViewModelController.user.value.userName,
                                messageController.text)
                            .then((value) {
                          messageController.clear();
                        });
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Message extends StatefulWidget {
  final String from;
  final String text;
  final String to;
  final bool me;
  final Timestamp time;
  bool read;

  Message(
      {Key? key,
      required from,
      required text,
      required to,
      required me,
      required read,
      required time})
      : from = from,
        text = text,
        to = to,
        me = me,
        read = read,
        time = time;

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  UserViewModel userViewModelController = Get.find<UserViewModel>();
  String friend = '';

  Future<void> getName() async {
    FirebaseFirestore.instance
        .collection('user')
        .doc(widget.from)
        .get()
        .then((value) {
      setState(() {
        friend = value.get('userName');
      });
    });
  }

  void initState() {
    super.initState();
    if (!widget.me) getName();
    // else friend = '2';
  }

  @override
  Widget build(BuildContext context) {
    String _me = userViewModelController.user.value.userName;
    String _friend = widget.from;
    // late String friend;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        child: Column(
          crossAxisAlignment:
              widget.me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: widget.me
                  ? Text(
                      _me,
                    )
                  : Text(
                      friend,
                    ),
            ),
            Wrap(
              children: <Widget>[
                widget.me
                    ? Container(
                        margin: EdgeInsets.only(right: 5, top: 20),
                        child: widget.read
                            ? Text(
                                'V',
                                style: TextStyle(color: Orange400),
                              )
                            : Text(''))
                    : SizedBox(height: 0),
                widget.me
                    ? Container(
                        margin: EdgeInsets.only(right: 5, top: 20),
                        child: Text(widget.time.toDate().hour.toString() +
                            ':' +
                            widget.time.toDate().minute.toString()))
                    : SizedBox(height: 0),
                Container(
                  margin: widget.me
                      ? EdgeInsets.only(right: 10)
                      : EdgeInsets.only(left: 10),
                  child: Material(
                    color:
                        widget.me ? Colors.orangeAccent[100] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10.0),
                    elevation: 6.0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      child: Text(
                        widget.text,
                      ),
                    ),
                  ),
                ),
                widget.me
                    ? SizedBox(height: 0)
                    : Container(
                        margin: EdgeInsets.only(left: 5, top: 20),
                        child: Text(widget.time.toDate().hour.toString() +
                            ':' +
                            widget.time.toDate().minute.toString())),
                widget.me
                    ? SizedBox(height: 0)
                    : Container(
                        margin: EdgeInsets.only(left: 5, top: 20),
                        child: widget.read
                            ? Text(
                                'V',
                                style: TextStyle(color: Orange400),
                              )
                            : Text(''))
              ],
            )
          ],
        ),
      ),
    );
  }
}
