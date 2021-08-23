import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:mangodevelopment/app.dart';
import 'package:mangodevelopment/color.dart';
import 'package:mangodevelopment/viewModel/authentication.dart';

import '../../landing.dart';

class LogInPage extends StatelessWidget {
  final title;
  var authController = Get.find<Authentication>();

  LogInPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GetBuilder<Authentication>(
        init: Authentication(),
        builder: (_) {
          return Scaffold(
            backgroundColor: Theme.of(context).accentColor,
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
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: MangoWhite),
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
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(color: MangoWhite),
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
                  loginMethodWidget(platform, context),
                  Spacer(
                    flex: 4,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget loginMethodWidget(bool isIOS, context) {
    var loginWidth = 275.0;
    var loginHeight = 275.0;

    var logoSize = 25.0;
    var buttonHeightRatio = 1.4;
    var borderRatio = 5.0;

    return Container(
      alignment: Alignment.center,
      width: loginWidth * (deviceWidth / prototypeWidth),
      child: Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              width: loginWidth * (deviceWidth / prototypeWidth),
              height:
              logoSize * (deviceWidth / prototypeWidth) * buttonHeightRatio,
            ),
            child: TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image(
                    image: AssetImage('images/login/google_logo.png'),
                    width: logoSize * (deviceWidth / prototypeWidth),
                    height: logoSize * (deviceWidth / prototypeWidth),
                  ),
                  Text(
                    '구글 계정으로 시작하기',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Get.find<Authentication>().googleLogin().then((value) async{
                  await authController.loadId();
                  Get.off(Landing());
                });
              },
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(20),),
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              width: loginWidth * (deviceWidth / prototypeWidth),
              height:
              logoSize * (deviceWidth / prototypeWidth) * buttonHeightRatio,
            ),
            child: TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image(
                    image: AssetImage('images/login/kakao_logo.png'),
                    width: logoSize * (deviceWidth / prototypeWidth),
                    height: logoSize * (deviceWidth / prototypeWidth),
                  ),
                  Text(
                    '카카오 계정으로 시작하기',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Get.find<Authentication>().kakaoLogin().then((value){
                  authController.loadId();
                  Get.off(Landing());
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}