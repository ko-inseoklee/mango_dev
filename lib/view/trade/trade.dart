import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mangodevelopment/model/post.dart';
import 'package:mangodevelopment/view/trade/friend/friendList.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/widget/postCardWidget.dart';
import 'package:mangodevelopment/viewModel/push_test.dart';

import 'Chat/chatList.dart';

class TradePage extends StatefulWidget {
  final String title;

  const TradePage({Key? key, required this.title}) : super(key: key);

  @override
  _TradePageState createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  List<Post> Posts = localPostList.loadPostList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.person),
          onPressed: () {
            Get.to(FriendListPage());
          },
        ),
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.to(ChatList());
              },
              icon: Icon(Icons.chat_bubble_outline_outlined)),
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none))
        ],
      ),
      body: ListView.builder(
          itemCount: Posts.length,
          itemBuilder: (context, int index) {
            return MangoPostCard(
              postID: Posts[index].postID,
              state: Posts[index].state,
              foodName: Posts[index].foodName,
              owner: Posts[index].uid,
              profileImageRef: Posts[index].profileImageRef,
              createTime: Posts[index].registTime,
              subtitle: Posts[index].subtitle,
              num: Posts[index].num,
              shelfLife: Posts[index].shelfLife,
              userName: Posts[index].userName,
            );
          }),
      // Center(

      // child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      // InkWell(
      //   onTap: (){
      //     Get.to(Test());
      //   },
      //   child: Image(
      //     image: AssetImage('images/login/logo.png'),
      //   ),
      // ),
      // Text(
      //   '친구를 추가해서 \n거래를 시작해보세요',
      //   textAlign: TextAlign.center,
      // ),
      // ]),
      // ),
    );
  }
}
