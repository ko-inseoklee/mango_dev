import 'package:flutter/material.dart';

class FriendListPage{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('친구 목록'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('친구 없음'),
      ),
    );
  }
}