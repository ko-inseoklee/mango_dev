import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../color.dart';

var deviceWidth = 375.0;
var deviceHeight = 812.0;
var prototypeWidth = 375.0;
var prototypeHeight = 812.0;

class splashPage extends StatelessWidget {

  var _loginWidth = 275.0;
  var _loginHeight = 275.0;

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Widget loadingAppRun() {
    return Scaffold(
      backgroundColor: Orange500,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(
                flex: 20,
              ),
              Container(
                child: Text(
                  '당신의 냉장고를 관리해주는 집요정,',
                //   style: Theme.of(context)
                //       .textTheme
                //       .subtitle1
                //       .copyWith(color: MangoWhite),
                 ),
              ),
              Spacer(
                flex: 5,
              ),
              Container(
                child: Image.asset('images/login/appName.png'),
              ),
              Spacer(
                flex: 5,
              ),
              Container(
                child: Text(
                  'Manager + 古',
                  // style: Theme.of(context)
                  //     .textTheme
                  //     .caption
                  //     .copyWith(color: MangoWhite),
                ),
              ),
              Spacer(
                flex: 4,
              ),
              Image(
                image: AssetImage('images/login/logo.png'),
                height: 140,
                fit: BoxFit.contain,
              ),
              Spacer(
                flex: 4,
              ),
              Container(
                alignment: Alignment.center,
                width: _loginWidth * (deviceWidth / prototypeWidth),
                height: _loginHeight * (deviceWidth / prototypeWidth),
                child: CircularProgressIndicator(
                  backgroundColor: MangoWhite,
                ),
              ),
              Spacer(
                flex: 4,
              ),
            ],
          )),
    );
  }
}

