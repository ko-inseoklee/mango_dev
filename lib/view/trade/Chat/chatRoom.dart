import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

    ChatRoomViewModel()
        .AccessChatRoom(widget.chatID, userViewModelController.userID);
  }

  final FirebaseFirestore mango_dev = FirebaseFirestore.instance;

  TextEditingController messageController = TextEditingController();

  ScrollController scrollController = ScrollController();

  UserViewModel userViewModelController = Get.find<UserViewModel>();

  Future<void> send(String chatID, String curr_uid) async {
    if (messageController.text.length > 0) {
      await mango_dev
          .collection('chatRooms')
          .where('chatID', isEqualTo: chatID)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          mango_dev
              .collection('chatRooms')
              .doc(element.id)
              .collection('messages')
              .add({
            'text': messageController.text,
            'from': curr_uid,
            'to': element.get('takerName') == curr_uid
                ? element.get('ownerName')
                : element.get('takerName'),
            'date': Timestamp.now(),
            'read': false,
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
                      widget.chatID, userViewModelController.userID);
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  List<DocumentSnapshot> docs = snapshot.data!.docs;

                  List messages = docs
                      .map((doc) => Message(
                            from: doc['from'],
                            text: doc['text'],
                            to: doc['to'],
                            me: userViewModelController.user.value.userName ==
                                doc['from'],
                            read: doc['read'],
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
                          widget.chatID, //generate docID by Post
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
                          userViewModelController.user.value.userName);
                      messageController.clear();
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

class Message extends StatelessWidget {
  final String from;
  final String text;
  final String to;
  final bool me;
  bool read;

  Message(
      {Key? key,
      required from,
      required text,
      required to,
      required me,
      required read})
      : from = from,
        text = text,
        to = to,
        me = me,
        read = read;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        child: Column(
          crossAxisAlignment:
              me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                from,
              ),
            ),
            Wrap(
              children: <Widget>[
                me
                    ? Container(
                        margin: EdgeInsets.only(right: 10),
                        child: read ? Text('v') : Text(''))
                    : SizedBox(height: 0),
                Container(
                  margin: me
                      ? EdgeInsets.only(right: 10)
                      : EdgeInsets.only(left: 10),
                  child: Material(
                    color: me ? Colors.orangeAccent[100] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10.0),
                    elevation: 6.0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      child: Text(
                        text,
                      ),
                    ),
                  ),
                ),
                me
                    ? SizedBox(height: 0)
                    : Container(
                        margin: EdgeInsets.only(right: 10),
                        child: read ? Text('v') : Text(''))
              ],
            )
          ],
        ),
      ),
    );
  }
}
