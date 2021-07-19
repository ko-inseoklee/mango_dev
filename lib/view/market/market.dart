import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/test/foodSections.dart';

class MarketPage extends StatelessWidget {
  final String title;

  MarketPage({Key? key, required this.title}) : super(key: key);

  var _controller1 =
      Get.put<RefrigeratorViewController>(RefrigeratorViewController());
  var _controller2 =
      Get.put<RefrigeratorViewController>(RefrigeratorViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: Text('마켓 페이지'),
      ),
    );
  }
}

//
// body: Column(
// children: [
// GetX<RefrigeratorViewController>(
// init: _controller1,
// builder: (_) {
// return _.foodSection.value.refIsFold
// ? Text(_.foodSection.value.refIsFold.toString())
//     : Text('아니다임마!');
// },
// ),
// TextButton(
// onPressed: () {
// _controller1.changeRefIsFold(
// isFold: !_controller1.foodSection.value.refIsFold);
// },
// child: Text('rev1')),
// GetX<RefrigeratorViewController>(
// init: _controller2,
// builder: (_) {
// return _.foodSection.value.froIsFold
// ? Text(_.foodSection.value.froIsFold.toString())
//     : Text('아니다임마!');
// },
// ),
// TextButton(
// onPressed: () {
// _controller2.changeFroIsFold(
// isFold: !_controller2.foodSection.value.froIsFold);
// },
// child: Text('rev2'))
// ],
// ),
