import 'package:flutter/material.dart';
import 'package:mangodevelopment/view/market/friend/friendList.dart';
import 'package:get/get.dart';

class TradePage extends StatefulWidget {
  final String title;

  const TradePage({Key? key, required this.title}) : super(key: key);

  @override
  _TradePageState createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: InkWell(
            onTap: () {
              Get.to(FriendListPage());
            },
            child: Text('거래 페이지')),
      ),
    );
  }
}
