import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/color.dart';
import 'package:mangodevelopment/viewModel/categoryController.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';
import 'package:mangodevelopment/viewModel/tempUserViewModel.dart';
import '../../app.dart';
import '../widget/appBar.dart';
import 'addFoodDirect.dart';

class RefrigeratorPage extends StatefulWidget {
  final String title;

  const RefrigeratorPage({Key? key, required this.title}) : super(key: key);

  @override
  _RefrigeratorPageState createState() => _RefrigeratorPageState();
}

class _RefrigeratorPageState extends State<RefrigeratorPage>
    with SingleTickerProviderStateMixin {
  late TempUserViewModel currentUser;
  late RefrigeratorViewModel _refrigerator;

  TabController? _tabController;

  int tabIdx = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController =
        new TabController(length: 3, vsync: this, initialIndex: tabIdx);
  }

  @override
  Widget build(BuildContext context) {
    _refrigerator = Get.put(RefrigeratorViewModel());

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: MangoAppBar(
          isLeading: false,
          title: '나의 냉장고',
        ),
        backgroundColor: MangoWhite,
        body: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 40,
                  child: TabBar(
                      controller: _tabController,
                      indicatorColor: Orange400,
                      onTap: (value) async {
                        await _refrigerator.loadFoods();
                        setState(() {
                          tabIdx = value;
                        });
                      },
                      tabs: showTab())),
              Expanded(
                  child: tabIdx == 0
                      ? ShowInOnce()
                      : tabIdx == 1
                          ? ShowInCategories()
                          : ShowInShelfLife())
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> showTab() {
    return <Widget>[
      Text(
        '한눈에 보기',
        style: Theme.of(context)
            .textTheme
            .subtitle2!
            .copyWith(color: tabIdx == 0 ? Orange400 : MangoDisabledColor),
      ),
      Text(
        '카테고리별 보기',
        style: Theme.of(context)
            .textTheme
            .subtitle2!
            .copyWith(color: tabIdx == 1 ? Orange400 : MangoDisabledColor),
      ),
      Text('유통기한별 보기',
          style: Theme.of(context)
              .textTheme
              .subtitle2!
              .copyWith(color: tabIdx == 2 ? Orange400 : MangoDisabledColor)),
    ];
  }
}

class ShowInOnce extends StatefulWidget {
  ShowInOnce({Key? key}) : super(key: key);

  @override
  _ShowInOnceState createState() => _ShowInOnceState();
}

class _ShowInOnceState extends State<ShowInOnce> {
  late RefrigeratorViewModel _refrigerator;

  late List<TemporaryFood> _refrigerationFoods;

  late List<TemporaryFood> _frozenFoods;

  late List<TemporaryFood> _roomTempFoods;

  bool _foldAll = true;
  bool _foldRefrigerator = true;
  bool _foldFrozen = true;
  bool _foldRoomTemp = true;

  @override
  Widget build(BuildContext context) {
    _refrigerator = Get.find();

    print(_refrigerator.myFoodsViewModel.value.foods!.length);

    _refrigerationFoods = _refrigerator.myFoodsViewModel.value
        .sortByStoreType(_refrigerator.myFoodsViewModel.value.foods!, 0);
    _frozenFoods = _refrigerator.myFoodsViewModel.value
        .sortByStoreType(_refrigerator.myFoodsViewModel.value.foods!, 1);
    _roomTempFoods = _refrigerator.myFoodsViewModel.value
        .sortByStoreType(_refrigerator.myFoodsViewModel.value.foods!, 2);

    return ListView(
      children: [
        Container(
          height: 50,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '전체 ${_refrigerator.myFoodsViewModel.value.foods!.length}개',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: MangoDisabledColorDark),
                ),
              ),
              Spacer(),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _foldAll = !_foldAll;
                      _foldRefrigerator = _foldAll;
                      _foldFrozen = _foldAll;
                      _foldRoomTemp = _foldAll;
                    });
                  },
                  child: Text(
                    _foldAll ? '모두 펼치기' : '모두 접기',
                    style: Theme.of(context).textTheme.subtitle2,
                  )),
              TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text(
                        '선택',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(color: MangoDisabledColorDark),
                      ),
                      SizedBox(
                        width: 2.0,
                      ),
                      Icon(
                        Icons.check_circle_outline,
                        color: MangoDisabledColorDark,
                        size: 18.0,
                      )
                    ],
                  )),
            ],
          ),
        ),
        Container(
          height: 8.0 * deviceHeight / prototypeHeight,
          decoration: BoxDecoration(
              color: MangoBehindColor,
              border: Border(top: BorderSide(color: MangoDisabledColorLight))),
        ),
        Container(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(12.0, 8.0, 0, 8.0),
                      child: Text(
                        '냉장',
                        style: Theme.of(context).textTheme.headline6,
                      )),
                  Spacer(),
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 8.0, 4.0, 8.0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _foldRefrigerator = !_foldRefrigerator;
                            _foldAll = checkAllFold();
                          });
                        },
                        child: Icon(
                          _foldRefrigerator
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                          color: MangoBlack,
                          size: 26,
                        ),
                      ))
                ],
              ),
              Container(
                child: _foldRefrigerator
                    ? Text('')
                    : _refrigerationFoods.length == 0
                        ? Container(
                            alignment: Alignment.center,
                            height: 100,
                            child: Text('냉장고가 비었습니다.'),
                          )
                        : Container(
                            height: 200,
                            child: GridView.count(
                              crossAxisCount: 3,
                              childAspectRatio: 50 / 60,
                              children: _buildFoodCards(_refrigerationFoods),
                            ),
                          ),
              ),
            ],
          ),
        ),
        Container(
          height: 8.0 * deviceHeight / prototypeHeight,
          decoration: BoxDecoration(
              color: MangoBehindColor,
              border: Border(top: BorderSide(color: MangoDisabledColorLight))),
        ),
        Container(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(12.0, 8.0, 0, 8.0),
                      child: Text(
                        '냉동',
                        style: Theme.of(context).textTheme.headline6,
                      )),
                  Spacer(),
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 8.0, 4.0, 8.0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _foldFrozen = !_foldFrozen;
                            _foldAll = checkAllFold();
                          });
                        },
                        child: Icon(
                          _foldFrozen
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                          color: MangoBlack,
                          size: 26,
                        ),
                      ))
                ],
              ),
              Container(
                child: _foldFrozen
                    ? Text('')
                    : _frozenFoods.length == 0
                        ? Container(
                            alignment: Alignment.center,
                            height: 100,
                            child: Text('냉장고가 비었습니다.'),
                          )
                        : Container(
                            height: 200,
                            child: GridView.count(
                              crossAxisCount: 3,
                              childAspectRatio: 50 / 60,
                              children: _buildFoodCards(_frozenFoods),
                            ),
                          ),
              ),
            ],
          ),
        ),
        Container(
          height: 8.0 * deviceHeight / prototypeHeight,
          decoration: BoxDecoration(
              color: MangoBehindColor,
              border: Border(top: BorderSide(color: MangoDisabledColorLight))),
        ),
        Container(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(12.0, 8.0, 0, 8.0),
                      child: Text(
                        '실온',
                        style: Theme.of(context).textTheme.headline6,
                      )),
                  Spacer(),
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 8.0, 4.0, 8.0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _foldRoomTemp = !_foldRoomTemp;
                            _foldAll = checkAllFold();
                          });
                        },
                        child: Icon(
                          _foldRoomTemp
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                          color: MangoBlack,
                          size: 26,
                        ),
                      ))
                ],
              ),
              Container(
                child: _foldRoomTemp
                    ? Text('')
                    : _roomTempFoods.length == 0
                        ? Container(
                            alignment: Alignment.center,
                            height: 100,
                            child: Text('냉장고가 비었습니다.'),
                          )
                        : Container(
                            height: 200,
                            child: GridView.count(
                              crossAxisCount: 3,
                              childAspectRatio: 50 / 60,
                              children: _buildFoodCards(_roomTempFoods),
                            ),
                          ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFoodCard(TemporaryFood food) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
              'images/category/${categoryImg[translateToKo(food.category)]}'),
          Text(food.name),
          Text(food.displayType
              ? '${food.shelfLife}까지'
              : '${food.registrationDay}부터'),
          Text(food.number.toString())
        ],
      ),
    );
  }

  List<Widget> _buildFoodCards(List<TemporaryFood> foods) {
    return foods.map((e) => _buildFoodCard(e)).toList();
  }

  bool checkAllFold() {
    return _foldRefrigerator && _foldRoomTemp && _foldFrozen;
  }
}

class ShowInCategories extends StatelessWidget {
  const ShowInCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('카테고리별 보기'));
  }
}

class ShowInShelfLife extends StatelessWidget {
  const ShowInShelfLife({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('유통기한별 보기'));
  }
}
