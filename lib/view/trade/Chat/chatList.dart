import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/trade/Chat/chatDetail.dart';
import 'package:mangodevelopment/view/trade/Chat/chatRoom.dart';
import 'package:mangodevelopment/view/widget/appBar.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  FirebaseFirestore mango_dev = FirebaseFirestore.instance;
  UserViewModel userViewModelController = Get.find<UserViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('채팅 목록'),
      ),
      body: StreamBuilder<QuerySnapshot>(
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
                return InkWell(
                  onTap: () {
                    Get.to(ChatRoom(
                      chatID: documents.elementAt(index).get('chatID'),
                      friendName: documents.elementAt(index).get('friend'),
                    ));
                  },
                  child: ListTile(
                    title: Text(documents.elementAt(index).get('friend')),
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
