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
  List<String> friendName = [];
  List<bool> _read = [];

  @override
  void initState() {
    _text = List.filled(1000, ' ');
    friendName = List.filled(1000, ' ');
    _read = List.filled(1000, true);
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

  Future<void> getName(String friend, int index) async {
    FirebaseFirestore.instance
        .collection('user')
        .doc(friend)
        .get()
        .then((value) {
      setState(() {
        friendName[index] = value.get('userName');
      });
    });
  }

  Future<void> getRead(String docID, int index) async {
    mango_dev
        .collection('chatRooms')
        .doc(docID)
        .collection('messages')
        .where('to', isEqualTo: userViewModelController.user.value.userID)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        mango_dev
            .collection('chatRooms')
            .doc(docID)
            .collection('messages')
            .doc(element.id)
            .get()
            .then((value) {
          if (value.data()!['read'].toString() == 'false') {
            setState(() {
              _read[index] = false;
            });
          }
        });
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
                getRead(documents.elementAt(index).get('chatID'), index);
                getMessage(documents.elementAt(index).get('chatID'), index);
                getName(documents.elementAt(index).get('friend'), index);

                return InkWell(
                  onTap: () {
                    // TODO: post가 삭제된 chatRoom 들어갈때 넘겨주는 post 정보 확인하기
                    Get.to(ChatRoom(
                        chatID: documents.elementAt(index).get('chatID'),
                        friendName: documents.elementAt(index).get('friend')));
                  },
                  child: ListTile(
                    title: Text(friendName[index]),
                    subtitle: Text(_text[index]),
                    trailing: _read[index]
                        ? SizedBox()
                        : CircleAvatar(
                            child: Text(
                              'N',
                              style: TextStyle(fontSize: 12),
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            radius: 12,
                          ),
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
