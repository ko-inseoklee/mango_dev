import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

class ChatDetailPage extends StatefulWidget {
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  var friendId = Get.arguments[0];
  var postID = Get.arguments[1];

  final FirebaseFirestore mango_dev = FirebaseFirestore.instance;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Future<void> callback(String docID, String from) async {
    print('CALLBACK');
    print('docID: ' + docID + ' from + ' + from);

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

    var category;

    // FirebaseFirestore.instance
    //     .collection('chatRooms')
    //     .doc(userViewModelController.user.value.userID)
    //     .get()
    //     .then((DocumentSnapshot ds) {
    //   setState(() {
    //     category = ds.get('category');
    //   });
    // });

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

                  return ListView(
                    controller: scrollController,
                    children: <Widget>[
                      ...messages,
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
                      // onSubmitted: (value) => callback(
                      //     postID, //generate docID by Post
                      //     userViewModelController.user.value.userID),
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
                          : Colors.blue,
                    ),
                    onPressed: () {
                      callback(
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
              color: me ? Colors.blueAccent[100] : Colors.grey[300],
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
