import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/landing.dart';

class KakaoTestPage extends StatefulWidget {
  @override
  _KakaoTestPageState createState() => _KakaoTestPageState();
}

class _KakaoTestPageState extends State<KakaoTestPage> {
  bool _isKakaoInstalled = false;

  @override
  void initState() {
    _initKakaoInstalled();
    super.initState();
  }

  _initKakaoInstalled() async {
    final installed = await isKakaoTalkInstalled();
    print('kako installed: ' + installed.toString());
    setState(() {
      _isKakaoInstalled = installed;
    });
  }

  _issueAccessToken(String authCode) async {
    try {
      print("accessToken");
      var token = await AuthApi.instance.issueAccessToken(authCode);
      await AccessTokenStore.instance.toStore(token);
      print(token);
      Get.to(Landing());
    } catch (e) {
      print(e.toString());
    }
  }

  _loginWithKakao() async {
    try {
      print("kakao");
      var code = await AuthCodeClient.instance.request();
      print("kakao2");
      await _issueAccessToken(code);
    } catch (e) {
      print("error");
      print(e.toString());
    }
  }

  _loginWithTalk() async {
    try {
      var code = await AuthCodeClient.instance.requestWithTalk();
      await _issueAccessToken(code);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 500,
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: InkWell(
            child: Text('kakoLogin'),
            onTap: () async{
               _isKakaoInstalled ? _loginWithTalk() : _loginWithKakao();
            }
          ),
        ),
      ),
    );
  }
}
