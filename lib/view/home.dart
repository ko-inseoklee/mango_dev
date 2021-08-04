import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/test/testRef.dart';
import 'package:mangodevelopment/view/analyze/nutrition.dart';
import 'package:mangodevelopment/view/market/market.dart';
import 'package:mangodevelopment/view/myAccount/myPage.dart';
import 'package:mangodevelopment/view/refrigerator/addFoodSheet.dart';
import 'package:mangodevelopment/view/refrigerator/refrigerator.dart';
import 'package:mangodevelopment/view/refrigerator/test2.dart';
import 'package:mangodevelopment/view/refrigerator/testRefri.dart';
import 'package:mangodevelopment/view/trade/makePost.dart';
import 'package:mangodevelopment/view/trade/trade.dart';
import 'package:mangodevelopment/viewModel/authentication.dart';
import 'package:mangodevelopment/viewModel/postViewModel.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

import '../color.dart';
import '../viewModel/refrigeratorViewModel.dart';
import './widget/bottomNavigationBar/bottomNavigationBar.dart';

import 'dart:math' as math;

class HomePage extends StatefulWidget {
  final title;

  const                                                                                                                                                                                                                                                                                                                                           HomePage({Key? key, required this.title}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  MangoBNBController _controller = MangoBNBController();
  UserViewModel _userViewModelController = Get.put(UserViewModel());
  TestRefViewModel _refrigeratorViewModel = Get.put(TestRefViewModel());
  Authentication authController = Get.find<Authentication>();
  // postViewModel postController = Get.put(postViewModel());

  @override
  Widget build(BuildContext context) {
    // _userViewModelController
    //     .setUserInfo(authController.user!.uid)
    //     .then((value) {
    //   _refrigeratorViewModel.loadRefID(
    //       rID: _userViewModelController.user.value.refrigeratorID);
    // });
    _userViewModelController.makeFriendList(authController.user!.uid);
    // _refrigeratorViewModel = Get.put(TestRefViewModel());

    return FutureBuilder(
        future: _userViewModelController.setUserInfo(authController.user!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            print('loading...');
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            _refrigeratorViewModel
                .loadRefID(
                    rID: _userViewModelController.user.value.refrigeratorID)
                .then((value) => print(
                    'finish loading = ${_refrigeratorViewModel.ref.value.rID}'));

            return GetBuilder<MangoBNBController>(
              init: _controller,
              builder: (_) {
                return Scaffold(
                  body: SafeArea(
                    child: IndexedStack(
                      index: _controller.tabIndex.value,
                      children: [
                        // RefrigeratorPage(title: '나의 냉장고'),
                        // SubRefrigeratorPage(
                        //   title: '나의 냉장고',
                        // ),
                        TestRefPage(
                          title: '나의 냉장고',
                        ),
                        MarketPage(title: '마켓 페이지'),
                        TradePage(title: '거래 광장 페이지'),
                        NutritionPage(title: '영양 정보 페이지'),
                        MyPage(title: '마이 페이지'),
                      ],
                    ),
                  ),
                  floatingActionButton: MangoFAB(
                    distance: 55.0,
                    children: [
                      ActionButton(
                        onPressed: () => _showAction(context, 0),
                        icon: const Icon(Icons.kitchen_outlined),
                      ),
                      ActionButton(
                        onPressed: () => _showAction(context, 1),
                        icon: const Icon(Icons.local_mall_outlined),
                      ),
                    ],
                  ),
                  bottomNavigationBar: MangoBottomNavigationBar(
                    controller: _controller,
                  ),
                );
              },
            );
          }
        });
  }

  void _showAction(BuildContext context, int index) {
    if (index == 0)
      Get.dialog(AddFoodSheet());
    else
      Get.to(MakePostPage(title: '거래 품목 등록'));
  }
}

class MangoFAB extends StatefulWidget {
  const MangoFAB({
    Key? key,
    this.initialOpen,
    required this.distance,
    required this.children,
  }) : super(key: key);

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  _MangoFABState createState() => _MangoFABState();
}

class _MangoFABState extends State<MangoFAB>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: ScreenUtil().setWidth(58),
      height: ScreenUtil().setHeight(60),
      child: Center(
        child: Material(
          color: Orange400,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            backgroundColor: Orange400,
            onPressed: _toggle,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

class _ExpandingActionButton extends StatelessWidget {
  _ExpandingActionButton({
    Key? key,
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  }) : super(key: key);

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    this.onPressed,
    required this.icon,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: theme.accentColor,
      elevation: 4.0,
      child: IconTheme.merge(
        data: theme.accentIconTheme,
        child: IconButton(
          onPressed: onPressed,
          icon: icon,
        ),
      ),
    );
  }
}

@immutable
class FakeItem extends StatelessWidget {
  const FakeItem({
    Key? key,
    required this.isBig,
  }) : super(key: key);

  final bool isBig;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      height: isBig ? 128.0 : 36.0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: Colors.grey.shade300,
      ),
    );
  }
}
