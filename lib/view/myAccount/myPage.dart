import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/color.dart';
import 'package:mangodevelopment/view/myAccount/myPageEdit.dart';
import 'package:mangodevelopment/view/widget/dialog/dialog.dart';
import 'package:mangodevelopment/view/widget/setting/settingMenu.dart';
import 'package:mangodevelopment/viewModel/authentication.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

import '../../app.dart';

class MyPage extends StatefulWidget {
  final String title;

  const MyPage({Key? key, required this.title}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Authentication _auth = Get.find<Authentication>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserViewModel>(builder: (userViewModelController) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        backgroundColor: MangoWhite,
        body: Center(
          child: Column(
            children: [
              Container(
                height: 130 * deviceHeight / prototypeHeight,
                child: Row(
                  children: [
                    //TODO: should change the case of false condition with get image from firebase storage. Should change Using Stack for modify image button.
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          35 * deviceWidth / prototypeWidth,
                          5 * deviceWidth / prototypeWidth,
                          0,
                          5 * deviceWidth / prototypeWidth),
                      child: Container(
                        width: 90 * deviceWidth / prototypeWidth,
                        height: 90 * deviceWidth / prototypeWidth,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: userViewModelController
                                        .user.value.profileImageReference ==
                                    '-1'
                                ? AssetImage('images/default_profile.png')
                                : AssetImage('images/default_profile.png'),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(16.0* deviceWidth / prototypeWidth, 40.0 * deviceWidth / prototypeWidth, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userViewModelController.user.value.userName,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Text('${_auth.user!.email}'),
                          ],
                        ),
                      ),
                    ),
                    //TODO. 수정페이지로 이동
                    IconButton(onPressed: (){
                      Get.off(MyPageEdit());
                    }, icon: Icon(Icons.arrow_forward_ios_sharp))
                  ],
                ),
              ),
              Container(
                height: 7 * deviceHeight / prototypeHeight,
                color: MangoBehindColor,
              ),
              Container(
                padding: EdgeInsets.all(5.0 * deviceWidth / prototypeWidth),
                height: 250 * deviceHeight / prototypeHeight,
                child: Center(
                  child: GridView.count(
                    crossAxisCount: 4,
                    children: _buildGridMenu(),
                  ),
                ),
              ),
              Container(
                height: 7 * deviceHeight / prototypeHeight,
                color: MangoBehindColor,
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(7 * deviceWidth / prototypeWidth,
                      0, 7 * deviceWidth / prototypeWidth, 0),
                  children: [
                    settingMenu(
                      menuName: "자주 묻는 질문",
                      onTap: () {
                        comingSoon(context);
                      },
                      trailingWidth: 10,
                      trailing: SizedBox(),
                    ),
                    settingMenu(
                      menuName: "공지사항",
                      onTap: () {
                        comingSoon(context);
                      },
                      trailingWidth: 10,
                      trailing: SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  List<Widget> _buildGridMenu() {
    List<myAccountMenu> _menus = [
      myAccountMenu(
          menuName: '전체 거래 내역', iconData: Icons.note_outlined, navRef: ''
          //navRef: APPSETTINGS
          ),
      myAccountMenu(
          menuName: '나의 거래 게시글',
          iconData: Icons.account_box_outlined,
          navRef: ''),
      myAccountMenu(
          menuName: 'MY MARKET',
          iconData: Icons.shopping_cart_outlined,
          navRef: ''),
      myAccountMenu(
          menuName: '냉장고 관리', iconData: Icons.kitchen_outlined, navRef: ''),
      myAccountMenu(
          menuName: '나의 영양 정보 관리',
          iconData: Icons.fact_check_outlined,
          navRef: ''),
      myAccountMenu(
          menuName: '알림 관리', iconData: Icons.notifications_none, navRef: ''),
      myAccountMenu(menuName: '앱 설정', iconData: Icons.settings, navRef: ''),
    ];

    return _menus.map((menu) {
      return Container(
        width: 85 * deviceWidth / prototypeWidth,
        height: 80 * deviceHeight / prototypeHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Orange50,
              ),
              child: IconButton(
                alignment: Alignment.center,
                icon: Icon(
                  menu.iconData,
                  size: 28 * deviceWidth / prototypeWidth,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {},
                //TODO: condition should be deleted after make certain contents.
                // onPressed: () => menu.menuName == '앱 설정'
                //     ? Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => settingAppPage(
                //       title: "앱 설정",
                //     )))
                //     : menu.menuName == '알림 관리'
                //     ? Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => settingAlarmPage(
                //       title: "알림 관리",
                //     )))
                //     : comingSoon(context),
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(top: 5.0 * deviceHeight / prototypeHeight),
              child: Text(
                menu.menuName,
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

class myAccountMenu {
  @required
  String menuName;
  @required
  String navRef;
  @required
  IconData iconData;

  myAccountMenu(
      {required this.menuName, required this.iconData, required this.navRef});
}
