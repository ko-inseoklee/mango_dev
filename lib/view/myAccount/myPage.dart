import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  final String title;

  const MyPage({Key? key, required this.title}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Text('마이 페이지'),
      ),
    );
  }
}
