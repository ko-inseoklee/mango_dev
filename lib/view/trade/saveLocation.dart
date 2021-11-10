import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

class saveLocation extends StatefulWidget {
  @override
  _saveLocationState createState() => _saveLocationState();
}

class _saveLocationState extends State<saveLocation> {
  UserViewModel userViewModelController = Get.find<UserViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('거래 동네 설정하기'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(alignment: Alignment.center, child: Text('START')),
              SizedBox(height: 50),
              InkWell(
                onTap: () {
                  print('location:' +
                      userViewModelController.user.value.location.longitude
                          .toString());
                  // Get.to(Test());
                },
                child: Image(
                  fit: BoxFit.fill,
                  image: AssetImage('images/login/logo.png'),
                ),
              ),
              InkWell(
                onTap: () {
                  // Get.to(addLocationPage());
                },
                child: Text(
                  '위치 보를 등록하고 \n거래를 시작해보세요',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                // style: ButtonStyle(
                //   backgroundColor: Color(Colors.yellow),
                // ),
                onPressed: () {
                  print('Hi');
                },
                child: Text('위치 정보 등록하기'),
              )
            ]),
      ),
    );
  }
}
