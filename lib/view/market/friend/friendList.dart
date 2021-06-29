import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/market/friend/addEmail.dart';
import 'package:mangodevelopment/view/market/friend/addID.dart';
import 'package:mangodevelopment/view/market/friend/addPhone.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendListPage extends StatefulWidget {
  @override
  _FriendListPageState createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {
  FirebaseFirestore mango_dev = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('친구 목록'),
          actions: [
            IconButton(
              onPressed: () {
                print('HI');
              },
              icon: Icon(Icons.people),
            ),
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
          ],
          centerTitle: true,
        ),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: mango_dev.collection('temp_user').doc('123').snapshots(),
          builder: (_, snapshot) {
            if (snapshot.hasError) return Text('Error = ${snapshot.error}');

            if (snapshot.hasData) {
              var output = snapshot.data!.data();
              var value = output!['FriendList']; // <-- Your value
              return Text('Value = $value');
            }

            return Center(child: CircularProgressIndicator());
          },
        )
    );
  }

  Widget _buildListTile(BuildContext context, DocumentSnapshot docs) {
    return ListTile(
      title: Text(docs.get('name')),
    );
  }

  Widget _buildFriendList(DocumentSnapshot docs) {
    // String _refID;
    //   mango_dev.collection('temp_user').doc('123').get().then((doc) {
    //     print(doc['refID']);
    //     _name = doc['refID'];
    //
    //   });

    return ListTile(
      title: Text(docs.get('refID')),
    );
  }
}
