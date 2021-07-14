import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/model/user.dart';
import 'package:mangodevelopment/view/trade/friend/friendList.dart';
import 'package:mangodevelopment/viewModel/friendListViewModel.dart';
import 'package:mangodevelopment/landing.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

class AddIDPage extends StatefulWidget {
  @override
  _AddIDPageState createState() => _AddIDPageState();
}

class _AddIDPageState extends State<AddIDPage> {
  String _search = '';

  FirebaseFirestore mango_dev = FirebaseFirestore.instance;

  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserViewModel>(builder: (userViewModelController) {
      return Scaffold(
          appBar: AppBar(
            title: Text('ID로 추가하기'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoSearchTextField(
                      controller: _textController,
                      onChanged: (String value) {
                        setState(() {
                          _search = value;
                        });
                      },
                      onSubmitted: (String value) {
                        setState(() {
                          _search = value;
                        });
                      },
                      placeholder: '친구 검색',
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.grey[200]),
                      child: ListTile(
                        title: Text(
                          '내 아이디',
                        ),
                        trailing: Text(
                          // TODO: get current user info
                          userViewModelController.user.value.userName,
                          // UserViewModel().userID
                        ),
                      )),
                  Flexible(
                    child: StreamBuilder<QuerySnapshot>(
                        stream: (_search != '')
                            ? FirebaseFirestore.instance
                                .collection('user')
                                .where('userName', isEqualTo: _search)
                                .snapshots()
                            : FirebaseFirestore.instance
                                .collection('dummy')
                                .snapshots(),
                        builder: (context, snapshot) {
                          return (snapshot.connectionState ==
                                  ConnectionState.waiting)
                              ? Center(child: CircularProgressIndicator())
                              : ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot data =
                                        snapshot.data!.docs[index];
                                    return Card(
                                      child: ListTile(
                                        title: Text(data['userName']),
                                        trailing: IconButton(
                                            onPressed: () {
                                              Get.dialog(
                                                AlertDialog(
                                                  title: const Text('친구 등록'),
                                                  content: Text(
                                                      data['userName'] +
                                                          '님을 친구로 추가하시겠습니까?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child: const Text('취소'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        // TODO: 1. check if uid is already in the friend list
                                                        // TODO: 2. if not UPDATE friend list
                                                        print(
                                                            'add to friend list');
                                                        FriendListViewModel()
                                                            .addFriend(
                                                                // TODO: use current user info
                                                                userViewModelController
                                                                    .user
                                                                    .value
                                                                    .userID,
                                                                userViewModelController
                                                                    .user
                                                                    .value
                                                                    .userName,
                                                                data['userID'],
                                                                data[
                                                                    'userName']);
                                                        // TODO: get named until 사용 알아보기
                                                        Get.back();
                                                        Get.back();
                                                        Get.back();
                                                        // Get.offAndToNamed(
                                                        //     'FriendList');
                                                        // Get.offNamed(
                                                        //     'FriendList');
                                                      },
                                                      child: const Text('확인'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            icon:
                                                Icon(Icons.add_circle_outline)),
                                      ),
                                    );
                                  });
                        }),
                  ),
                ],
              ),
            ),
          ));
    });
  }
}
