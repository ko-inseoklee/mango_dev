import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  bool _isFirst = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: TextButton(
          onPressed: () {
            setState(() {
              _isFirst = !_isFirst;
            });
          },
          child: Image.asset(_isFirst
              ? 'images/prototype/chat1.png'
              : 'images/prototype/chat2.png'),
        ),
      ),
    );
  }
}
