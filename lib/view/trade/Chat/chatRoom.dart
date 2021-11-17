import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/viewModel/addFriendViewModel.dart';
import 'package:mangodevelopment/viewModel/chatRoomViewModel.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

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
  late String foodName = '-';
  late int foodNum = 0;
  late String subtitle = '-';

  @override
  void initState() {
    super.initState();

    mango_dev
        .collection('chatRooms')
        .where('chatID', isEqualTo: widget.chatID)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        _stream = element.reference.collection('messages').snapshots();
      });
    });

    mango_dev
        .collection('post')
        .where('chatList', arrayContains: widget.chatID)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        foodName = element.get('foodName');
        foodNum = element.get('foodNum');
        subtitle = element.get('subtitle');
        state = element.get('state');
      });
    });

    ChatRoomViewModel().AccessChatRoom(
        widget.chatID,
        userViewModelController.userID,
        userViewModelController.user.value.userName);
  }

  final FirebaseFirestore mango_dev = FirebaseFirestore.instance;

  TextEditingController messageController = TextEditingController();

  ScrollController scrollController = ScrollController();

  UserViewModel userViewModelController = Get.find<UserViewModel>();

  Future<void> send(String chatID, String curr_uid, String currName) async {
    if (messageController.text.length > 0) {
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
            'text': messageController.text,
            'from': curr_uid,
            'to': element.get('takerID') == curr_uid
                // ? mango_dev
                //     .collection('user')
                //     .doc(element.get('ownerID'))
                //     .get()
                //     .then((value) {
                //     print('user:' + value.get('userName'));
                //     return value.get('userName');
                //   })
                ? element.get('ownerID')
                : element.get('takerID'),
            // : mango_dev
            //     .collection('user')
            //     .doc(element.get('takerID'))
            //     .get()
            //     .then((value) {
            //     print('user:' + value.get('userName'));
            //     return value.get('userName');
            //   }),
            'date': Timestamp.now(),
            'read': false,
          });

          var _id = element.get('takerID') == curr_uid
              ? element.get('ownerID')
              : element.get('takerID');

          // print('_id: $_id');
          mango_dev.collection('user').doc(_id).get().then((value) {
            // print('token: ' + value.get('tokens'));
            sendMessage(
                value.get('tokens'),
                userViewModelController.user.value.userName,
                messageController.text);
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
    // TODO: send FCM
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel userViewModelController = Get.find<UserViewModel>();
    // var chatList = mango_dev.collection('chatRooms').doc(postID);

    // 0: 나눔중, 1: 거래중, 2: 거래완료
    String _state = '';
    if (state == 0) {
      setState(() {
        _state = '나눔중';
      });
    } else if (state == 1) {
      setState(() {
        _state = '거래 중';
      });
    } else if (state == 2) {
      setState(() {
        _state = '거래 완료';
      });
    }
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(widget.chatID)
          // title: Text(ownerName + ' ( ' + foodName + foodNum.toString() + '개 )'),
          ),
      body: SafeArea(
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

                  List messages = docs
                      .map((doc) => Message(
                            from: doc['from'],
                            // id to name
                            text: doc['text'],
                            to: doc['to'],
                            // id to name
                            me: userViewModelController.userID == doc['from'],
                            read: doc['read'],
                            time: doc['date'],
                          ))
                      .toList();

                  // TODO: check if chat page is null
                  var empty = true;
                  if (messages.toList().length == 0)
                    return Stack(
                      children: <Widget>[
                        Center(
                          child: Text('채팅을 시작해 보세요'),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListTile(
                              //TODO: change to post foodIMG
                              // leading: IconButton(
                              //   icon: Icon(Icons.camera),
                              //   onPressed: () => print('gg'),
                              // ),
                              title: Text(_state +
                                  ' ' +
                                  foodName +
                                  ' ' +
                                  foodNum.toString() +
                                  '개'),
                              subtitle: Text(subtitle),
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

                  if (docs.length != 0) empty = false;

                  return Stack(
                    children: <Widget>[
                      Container(
                        child: empty
                            ? Center(
                                child: Text('채팅을 시작해 보세요'),
                              )
                            : ListView(
                                controller: scrollController,
                                children: <Widget>[
                                  SizedBox(
                                    height: 100,
                                    child: Image.asset('images/login/logo.png'),
                                  ),
                                  ...messages,
                                ],
                              ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            //TODO: change to post foodIMG
                            // leading: IconButton(
                            //   icon: Icon(Icons.camera),
                            //   onPressed: () => print('gg'),
                            // ),
                            title: Text(_state +
                                ' ' +
                                foodName +
                                ' ' +
                                foodNum.toString() +
                                '개'),
                            subtitle: Text(subtitle),
                          ),
                        ),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0.5,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 1), // changes position of shadow
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
                    child: TextField(
                      onSubmitted: (value) => send(
                          widget.chatID,
                          userViewModelController.userID,
                          userViewModelController.user.value.userName),
                      // from who ?
                      decoration: InputDecoration(
                        hintText: 'Enter a Message...',
                        border: const OutlineInputBorder(),
                      ),
                      controller: messageController,
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
                              userViewModelController.user.value.userName)
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
  String _to = '', _from = '';

  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('user')
        .doc(widget.to)
        .get()
        .then((value) {
      setState(() {
        _to = value.get('userName');
      });
    });

    FirebaseFirestore.instance
        .collection('user')
        .doc(widget.from)
        .get()
        .then((value) {
      setState(() {
        _from = value.get('userName');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        child: Column(
          crossAxisAlignment:
              widget.me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                _from
                // widget.from,
              ),
            ),
            Wrap(
              children: <Widget>[
                widget.me
                    ? Container(
                        margin: EdgeInsets.only(right: 5),
                        child: widget.read ? Text('읽음') : Text(''))
                    : SizedBox(height: 0),
                widget.me
                    ? Container(
                        margin: EdgeInsets.only(right: 5),
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
                        margin: EdgeInsets.only(right: 5),
                        child: Text(widget.time.toDate().hour.toString() +
                            ':' +
                            widget.time.toDate().minute.toString()))
              ],
            )
          ],
        ),
      ),
    );
  }
}
