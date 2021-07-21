import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'addFriendViewModel.dart';

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('test'),
      ),
      body: Center(
        child: InkWell(
          child: Text('click here!'),
          onTap: () {
            // sendFriendRequest();
          },
        ),
      ),
    );
  }
}
