import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddIDPage extends StatefulWidget {
  @override
  _AddIDPageState createState() => _AddIDPageState();
}

class _AddIDPageState extends State<AddIDPage> {
  FirebaseFirestore mango_dev = FirebaseFirestore.instance;

  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    String _search = '';

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
                    print('$value!!');
                  },
                  onSubmitted: (String value) {
                    _search = value;
                    print('result: $_search');
                  },
                  placeholder: '친구 검색',
                ),
              ),
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: mango_dev.collection('temp_user').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Text('loading');
                    return ListView.builder(
                      itemCount: snapshot.data!.size,
                      itemExtent: 80.0,
                      itemBuilder: (context, index) {
                        List<DocumentSnapshot> documents = snapshot.data!.docs;
                        documents
                            .map((docs) =>
                                _buildListTile(context, docs, _search))
                            .toList();
                        return _buildListTile(
                            context, documents.elementAt(index), _search);
                      },
                    );
                  },
                ),
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

  Widget _buildListTile(
      BuildContext context, DocumentSnapshot docs, String _search) {
    print('Tile: $_search');
    if (_search == docs.id) {
      return ListTile(
        title: Text(docs.get('name')),
        leading: Icon(Icons.ac_unit),
        // onTap: () {},
      );
    } else {
      return SizedBox(height: 0);
    }
  }
}
