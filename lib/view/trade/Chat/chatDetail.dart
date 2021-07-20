import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

class ChatDetailPage extends StatefulWidget {
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

// required info from POST

class _ChatDetailPageState extends State<ChatDetailPage> {
  var postID = Get.arguments[0];
  var state = Get.arguments[1];
  var friendId = Get.arguments[2];
  var foodName = Get.arguments[3];
  var num = Get.arguments[4];
  var subtitle = Get.arguments[5];
  var shelfLife = Get.arguments[6];

  final FirebaseFirestore mango_dev = FirebaseFirestore.instance;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  // chatRoom Doc ID
  // 1.PostID  2.user+friend ID
  Future<void> send(String docID, String from) async {
    if (messageController.text.length > 0) {
      await mango_dev
          .collection('chatRooms')
          .doc(docID)
          .collection('messages')
          .add({
        'text': messageController.text,
        'from': from,
        'date': DateTime.now().toIso8601String().toString(),
        'to': friendId,
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
      appBar: AppBar(
        title: Text('채팅 페이지'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: mango_dev
                    .collection('chatRooms')
                    .doc(postID) // TODO: access to generated random docID
                    .collection('messages')
                    .orderBy('date')
                    .snapshots(),
                builder: (context, snapshot) {
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
                            me: userViewModelController.userID == doc['from'],
                          ))
                      .toList();

                  // TODO: check if chat page is null
                  var empty = true;
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
                                  ...messages,
                                ],
                              ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            //TODO: change to post foodIMG
                            leading: IconButton(
                              icon: Icon(Icons.camera),
                              onPressed: () => print('gg'),
                            ),
                            title: Text(_state +
                                ' ' +
                                foodName +
                                ' ' +
                                num.toString() +
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
                          postID, //generate docID by Post
                          userViewModelController.user.value.userID),
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
                          postID, //generate docID by Post
                          userViewModelController.user.value.userID);

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

  const Message(
      {Key? key, required from, required text, required to, required me})
      : from = from,
        text = text,
        to = to,
        me = me;

  @override
  Widget build(BuildContext context) {
    print(from);
    return Container(
      child: Column(
        crossAxisAlignment:
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            from,
          ),
          Container(
            margin: me ? EdgeInsets.only(right: 20) : EdgeInsets.only(left: 20),
            child: Material(
              color: me ? Colors.orangeAccent[100] : Colors.grey[300],
              borderRadius: BorderRadius.circular(10.0),
              elevation: 6.0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                child: Text(
                  text,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
