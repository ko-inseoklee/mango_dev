import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mangodevelopment/model/post.dart';
import 'package:mangodevelopment/view/trade/friend/friendList.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/widget/postCardWidget.dart';
import 'package:mangodevelopment/viewModel/postViewModel.dart';
import 'package:mangodevelopment/viewModel/push_test.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

import 'Chat/chatList.dart';

class TradePage extends StatefulWidget {
  final String title;

  const TradePage({Key? key, required this.title}) : super(key: key);

  @override
  _TradePageState createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  @override
  void initState() {
    super.initState();
    getFriendList(userViewModelController.user.value.userID);
    // _stream = mango_dev.collection(collectionPath)
  }

  FirebaseFirestore mango_dev = FirebaseFirestore.instance;

  // postViewModel post = Get.find<postViewModel>();
  UserViewModel userViewModelController = Get.find<UserViewModel>();

  List<String> _friendList = [];

  List<String> postIdList = [];

  bool checkFriend(DocumentSnapshot<Object> element) {
    return true;
  }

  void getPost() {
    for (int i = 0; i < _friendList.length; i++) {
      mango_dev
          .collection('post')
          .where('ownerID', isEqualTo: _friendList[i])
          .get()
          .then((QuerySnapshot value) {
        value.docs.forEach((element) {
          print(element['subtitle']);
          postIdList.add(element.id);
          // MangoPostCard(
          //     postID: element['postID'],
          //     state: element['state'],
          //     subtitle: element['subtitle'],
          //     createTime: element['createTime'],
          //     ownerID: element['ownerID'],
          //     ownerName: element['ownerName'],
          //     profileImageRef: element['profileImageRef'],
          //     foodName: element['foodName'],
          //     foodNum: element['foodNum'],
          //     shelfLife: element['shelfLife']);
        });
      });
    }
  }

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
      body: StreamBuilder<QuerySnapshot>(
        stream: mango_dev
            .collection('post')
            .where('ownerFriendList',
                arrayContains: userViewModelController.user.value.userID)
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
                return MangoPostCard(
                    postID: documents.elementAt(index)['postID'],
                    state: documents.elementAt(index)['state'],
                    foodName: documents.elementAt(index)['foodName'],
                    ownerID: documents.elementAt(index)['ownerID'],
                    profileImageRef:
                        documents.elementAt(index)['profileImageRef'],
                    registTime: documents.elementAt(index)['registTime'],
                    subtitle: documents.elementAt(index)['subtitle'],
                    foodNum: documents.elementAt(index)['foodNum'],
                    shelfLife: documents.elementAt(index)['shelfLife'],
                    ownerName: documents.elementAt(index)['ownerName']);
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
              itemCount: snapshot.data!.size);
        },
      ),
      // Center(
      //   child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      //     InkWell(
      //       onTap: () {
      //         Get.to(Test());
      //       },
      //       child: Image(
      //         image: AssetImage('images/login/logo.png'),
      //       ),
      //     ),
      //     Text(
      //       '친구를 추가해서 \n거래를 시작해보세요',
      //       textAlign: TextAlign.center,
      //     ),
      //   ]),
      // ),
    );
  }

  void getFriendList(String uid) async {
    mango_dev
        .collection('user')
        .doc(uid)
        .collection('FriendList')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc['userName'] + '!');
        _friendList.add(doc['userID']);
      });
    });
  }
}
