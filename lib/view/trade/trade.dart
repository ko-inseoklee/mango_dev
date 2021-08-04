import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mangodevelopment/model/post.dart';
import 'package:mangodevelopment/view/trade/friend/friendList.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/widget/postCardWidget.dart';
import 'package:mangodevelopment/viewModel/postViewModel.dart';
import 'package:mangodevelopment/viewModel/push_test.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

import '../createPost.dart';
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
  }

  FirebaseFirestore mango_dev = FirebaseFirestore.instance;

  // postViewModel post = Get.find<postViewModel>();
  UserViewModel userViewModelController = Get.find<UserViewModel>();

  List<String> _friendList = [];

  List<String> postIdList = [];

  @override
  Widget build(BuildContext context) {
    getFriendList(userViewModelController.user.value.userID);
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
      // ignore: unrelated_type_equality_checks
      body: countDocuments(userViewModelController.user.value.userID) == 0
          ? Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(Test());
                      },
                      child: Image(
                        image: AssetImage('images/login/logo.png'),
                      ),
                    ),
                    Text(
                      '친구를 추가해서 \n거래를 시작해보세요',
                      textAlign: TextAlign.center,
                    ),
                  ]),
            )
          : StreamBuilder<QuerySnapshot>(
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
        _friendList.add(doc['userID']);
      });
    });
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
        });
      });
    }
  }

  Future<int> countDocuments(String curr_uid) async {
    QuerySnapshot _myDoc = await mango_dev
        .collection('user')
        .doc(curr_uid)
        .collection('FriendList')
        .get();

    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    print('count = ' + _myDocCount.length.toString());
    return _myDocCount.length; // Count of Documents in Collection
  }
}
