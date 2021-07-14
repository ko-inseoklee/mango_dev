import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/model/user.dart';
import 'package:mangodevelopment/viewModel/authentication.dart';
import 'package:mangodevelopment/view/trade/friend/addEmail.dart';
import 'package:mangodevelopment/view/trade/friend/addID.dart';
import 'package:mangodevelopment/view/trade/friend/addPhone.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mangodevelopment/viewModel/friendListViewModel.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

class FriendListPage extends StatefulWidget {
  @override
  _FriendListPageState createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {
  String _search = '';

  FirebaseFirestore mango_dev = FirebaseFirestore.instance;

  bool _edit = false;

  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: '');
  }

  Authentication _auth = Get.find<Authentication>();

  var _friendNum = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserViewModel>(builder: (userViewModelController) {
      return Scaffold(
          appBar: AppBar(
            title: Text('친구 목록'),
            leading: !_edit
                ? IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back))
                : ButtonTheme.fromButtonThemeData(
                    data: Theme.of(context).buttonTheme.copyWith(minWidth: 70),
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            _edit = false;
                          });
                        },
                        child: Text(
                          '완료',
                        )),
                  ),
            actions: [
              if (!_edit)
                IconButton(
                    onPressed: () {
                      Get.bottomSheet(
                          Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                      title: Text('연락처로 추가',
                                          textAlign: TextAlign.center),
                                      onTap: () {
                                        Get.to(AddPhonePage());
                                      }),
                                  Divider(thickness: 1, height: 1),
                                  ListTile(
                                      title: Text('이메일로 추가',
                                          textAlign: TextAlign.center),
                                      onTap: () {
                                        Get.to(AddEmailPage());
                                      }),
                                  Divider(thickness: 1, height: 1),
                                  ListTile(
                                      title: Text('ID로 추가',
                                          textAlign: TextAlign.center),
                                      onTap: () {
                                        Get.to(AddIDPage());
                                      })
                                ],
                              ),
                            ),
                          ),
                          elevation: 10.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0))));
                    },
                    icon: Icon(Icons.person_add_alt)),
              if (!_edit)
                IconButton(
                    onPressed: () {
                      setState(() {
                        _edit = true;
                      });
                    },
                    icon: Icon(Icons.settings)),
            ],
            centerTitle: true,
          ),
          body: Padding(
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
                  Divider(
                    thickness: 1,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      // backgroundImage: AssetImage(''),
                    ),
                    title: Text(
                      userViewModelController.user.value.userName,
                    ),
                  ),
                  Divider(thickness: 1),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('친구 ' + _friendNum.toString())),
                  ),
                  Flexible(
                    child: StreamBuilder<QuerySnapshot>(
                      // TODO: doc id => current uid 로!!
                      stream: (_search != '')
                          ? mango_dev
                              .collection('user')
                              .doc(
                                userViewModelController.user.value.userID,
                              )
                              .collection('FriendList')
                              .where('case', arrayContains: _search)
                              .snapshots()
                          : FirebaseFirestore.instance
                              .collection('user')
                              .doc(userViewModelController.user.value.userID)
                              .collection('FriendList')
                              .snapshots(),

                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          _friendNum = snapshot.data!.size;

                          return ListView.separated(
                            itemCount: snapshot.data!.size,
                            itemBuilder: (context, index) {
                              List<DocumentSnapshot> documents =
                                  snapshot.data!.docs;
                              documents
                                  .map((docs) => _buildListTile(
                                      context,
                                      docs,
                                      userViewModelController
                                          .user.value.userID))
                                  .toList();
                              return _buildListTile(
                                  context,
                                  documents.elementAt(index),
                                  userViewModelController.user.value.userID);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider();
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              )));
    });
  }

  Widget _buildListTile(
      BuildContext context, DocumentSnapshot docs, String userID) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        // backgroundImage: AssetImage(''),
      ),
      title: Text(docs.get('userName')),
      trailing: !_edit
          ? Text('')
          : ElevatedButton(
              onPressed: () {
                // TODO: get current user info

                FriendListViewModel().deleteFriend(userID, docs.get('userID'));
                Get.defaultDialog(middleText: '삭제 완료');
              },
              child: Text('삭제'),
            ),
    );
  }
}
