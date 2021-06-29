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
                                        },
                                        icon: Icon(Icons.add_circle_outline)),
                                  ),
                                );
                              });
                    }),
              ),
              IconButton(
                  onPressed: () {
                    print('HI');
                  },
                  icon: Icon(Icons.add))
            ],
          ),
        ));
  }

  void getaResult() {}

  Widget _buildListTile(BuildContext context, DocumentSnapshot docs) {
    // print('Tile: $_search');
    // if (_search == docs.id) {
    return ListTile(
      title: Text(docs.get('name')),
      leading: Icon(Icons.ac_unit),
      // onTap: () {},
    );
    // } else {
    //   return SizedBox(height: 0);
    // }
  }
}
