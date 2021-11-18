import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/trade/Chat/chatRoom.dart';
import 'package:mangodevelopment/view/widget/appBar.dart';
import 'package:mangodevelopment/viewModel/chatRoomViewModel.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  FirebaseFirestore mango_dev = FirebaseFirestore.instance;
  UserViewModel userViewModelController = Get.find<UserViewModel>();

  List<String> _text = [];
  String friendName = '';

  @override
  void initState() {
    _text = List.filled(100, '-');

  }

  Future<void> getMessage(String docID, int index) async {
    mango_dev
        .collection('chatRooms')
        .doc(docID)
        .collection('messages')
        .orderBy('date', descending: true)
        .limit(1)
        .get()
        .then((value) {
      if (value.docs.length == 0) {
        setState(() {
          _text[index] = '대화 시작';
        });
      } else {
        setState(() {
          _text[index] = value.docs.first.get('text').toString();
        });
      }
    });
  }

  Future<void> getName(String friend) async {
    FirebaseFirestore.instance
        .collection('user')
        .doc(friend)
        .get()
        .then((value) {
      setState(() {
        friendName = value.get('userName');
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('채팅 목록'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // stream: mango_dev.collection('chatRooms').where('ownerID'),
        stream: mango_dev
            .collection('user')
            .doc(userViewModelController.userID)
            .collection('chatList')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.separated(
              itemBuilder: (context, index) {

                List<DocumentSnapshot> documents = snapshot.data!.docs;
                getMessage(documents.elementAt(index).get('chatID'), index);
                getName(documents.elementAt(index).get('friend'));

                return InkWell(
                  onTap: () {
                    Get.to(ChatRoom(
                      chatID: documents.elementAt(index).get('chatID'),
                      friendName: documents.elementAt(index).get('friend'),
                    ));
                  },
                  child: ListTile(
                    title: Text(friendName),
                    subtitle: Text(_text[index]),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
              itemCount: snapshot.data!.size);
        },
      ),
    );
  }
}
