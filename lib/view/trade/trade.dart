import 'package:flutter/material.dart';
import 'package:mangodevelopment/view/trade/friend/friendList.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/viewModel/push_test.dart';

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
        leading: IconButton(
          icon: Icon(Icons.person),
          onPressed: () {
            Get.to(FriendListPage());
          },
        ),
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          InkWell(
            onTap: (){
              Get.to(Test());
            },
            child: Image(
              image: AssetImage('images/login/logo.png'),
            ),
          ),
          Text(
            '친구를 추가해서 \n거래를 시작해보세요',
            textAlign: TextAlign.center,
          ),
        ]),
      ),
    );
  }
}
