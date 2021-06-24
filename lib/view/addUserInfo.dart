import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/color.dart';
import 'package:mangodevelopment/view/splash.dart';

class AddUserInfoPage extends StatefulWidget {
  @override
  _AddUserInfoPageState createState() => _AddUserInfoPageState();
}

class _AddUserInfoPageState extends State<AddUserInfoPage> {

  List<String> _pageTitle = ['개인정보 설정', '알림 주기 설정'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MangoBehindColor,
      appBar: AppBar(
        title: Text(_pageTitle[0],style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: MangoWhite,
      ),
      body: setPersonalDataPage(context),
    );
  }
  
  Widget setPersonalDataPage(BuildContext context){
    var _contentWidth = 350.0;

    return Container(
      color: MangoWhite,
      child: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top:20 * (deviceWidth / prototypeWidth)),
              width: _contentWidth * (deviceWidth * deviceHeight),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 14 * (deviceWidth / prototypeWidth), 0, 33 * (deviceWidth/prototypeWidth)),
              width: _contentWidth * (deviceWidth * deviceHeight),
              child: TextField(
                maxLength: 12,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[A-z]'))
                ],

              ),
            )
          ],
        ),
      ),
    );
  }
}
