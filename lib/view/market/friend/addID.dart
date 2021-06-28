import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AddIDPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ID로 추가하기'),
      ),
      body: SizedBox.expand(
        // child: SafeArea(
        //   minimum: EdgeInsets.all(0.1), child: SearchBar<>(
        //   cancellationWidget: Text('취소'),
        //   searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
        //   searchBarStyle: SearchBarStyle(padding: EdgeInsets.zero),
        //   placeHolder: ListView(),
        //
        // ),
        //
        // ),
      ),
    );
  }
}
