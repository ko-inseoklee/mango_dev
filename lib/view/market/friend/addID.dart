import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/market/friend/friendList.dart';

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
                        '123',
                      ),
                    )),
                Flexible(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: (_search != '')
                          ? FirebaseFirestore.instance
                              .collection('temp_user')
                              .where('uid', isEqualTo: _search)
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
                                      title: Text(data['name']),
                                      trailing: IconButton(
                                          onPressed: () {
                                            Get.dialog(
                                              AlertDialog(
                                                title: const Text('친구 등록'),
                                                content: Text(data['name'] +
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
                                                      addFriend(
                                                          // TODO: use current user info
                                                          '123',
                                                          '정현',
                                                          data['uid'],
                                                          data['name']);
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
                                          icon: Icon(Icons.add_circle_outline)),
                                    ),
                                  );
                                });
                      }),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> addFriend(
      String curr_uid, String curr_name, String uid, String name) async {
    if (curr_uid == uid) {
      print('자기를 추가할 수 없습니다');
      // TODO: alert 창 띄우기
      return;
    }

    var check = await mango_dev
        .collection('temp_user')
        .doc(curr_uid)
        .collection('FriendList')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();

    List<DocumentSnapshot> documents = check.docs;

    //이미 등록된 친구 일 경우 `snackbar` return
    if (documents.length > 0) {
      return Get.snackbar('친구 추가 실패', '이미 등록된 친구입니다.');
    }

    await mango_dev
        .collection('temp_user')
        .doc(curr_uid)
        .collection('FriendList')
        .add({
      'name': name,
      'uid': uid,
    }).then((_) {
      print('success');
    }).catchError((_) {
      print('error');
    });

    await mango_dev
        .collection('temp_user')
        .doc(uid)
        .collection('FriendList')
        .add({
          'name': curr_name,
          'uid': curr_uid,
        })
        .then((value) => print('success2'))
        .catchError((_) {
          print('error2');
        });

    return Get.snackbar('친구 추가 완료', name + '님이 친구로 추가되었습니다');
  }
}
