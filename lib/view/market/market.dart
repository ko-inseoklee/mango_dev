import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarketPage extends StatefulWidget {
  final String title;

  const MarketPage({Key? key, required this.title}) : super(key: key);

  @override
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Text('마켓 페이지'),
      ),
    );
  }
}
