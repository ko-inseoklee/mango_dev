import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                                          // TODO: 1. check if uid is already in the friend list
                                          // TODO: 2. if not UPDATE friend list
                                          print('add to friend list');
                                          addFriend(
                                              // TODO: use current user info
                                              '123',
                                              data['uid'],
                                              '정현',
                                              data['name']);
                                        },
                                        icon: Icon(Icons.add_circle_outline)),
                                  ),
                                );
                              });
                    }),
              ),
            ],
          ),
        ));
  }

  void addFriend(String curr_uid, String curr_name, String uid, String name) {
    if (curr_uid == uid) {
      print('자기를 추가할 수 없습니다');
      // TODO: alert 창 띄우기
      return;
    }
    mango_dev
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

    mango_dev.collection('temp_user').doc(uid).collection('FriendList').add({
      'name': curr_name,
      'uid': curr_uid,
    });
  }
}
