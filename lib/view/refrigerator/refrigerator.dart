import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/color.dart';
import 'package:mangodevelopment/view/widget/foodSections.dart';
import 'package:mangodevelopment/view/widget/mangoDivider.dart';
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
    _refrigerationFoods = _refrigerator.myFoodsViewModel.value
        .sortByStoreType(_refrigerator.myFoodsViewModel.value.foods!, 0);
    _frozenFoods = _refrigerator.myFoodsViewModel.value
        .sortByStoreType(_refrigerator.myFoodsViewModel.value.foods!, 1);
    _roomTempFoods = _refrigerator.myFoodsViewModel.value
        .sortByStoreType(_refrigerator.myFoodsViewModel.value.foods!, 2);

    return Column(
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
          height: deviceHeight - 250,
          child: ListView(
            children: [
              FoodSections(
                  title: '냉장',
                  isFold: _foldRefrigerator,
                  onPressed: () {
                    setState(() {
                      _foldRefrigerator = !_foldRefrigerator;
                      _foldAll = checkAllFold();
                    });
                  },
                  foods: _refrigerationFoods),
              FoodSections(
                  title: '냉동',
                  isFold: _foldFrozen,
                  onPressed: () {
                    setState(() {
                      _foldFrozen = !_foldFrozen;
                      _foldAll = checkAllFold();
                    });
                  },
                  foods: _frozenFoods),
              FoodSections(
                  title: '실온',
                  isFold: _foldRoomTemp,
                  onPressed: () {
                    setState(() {
                      _foldRoomTemp = !_foldRoomTemp;
                      _foldAll = checkAllFold();
                    });
                  },
                  foods: _roomTempFoods),
            ],
          ),
        ),
      ],
    );
  }

  bool checkAllFold() {
    return _foldRefrigerator && _foldRoomTemp && _foldFrozen;
  }
}

class ShowInCategories extends StatefulWidget {
  const ShowInCategories({Key? key}) : super(key: key);

  @override
  _ShowInCategoriesState createState() => _ShowInCategoriesState();
}

class _ShowInCategoriesState extends State<ShowInCategories> {
  late RefrigeratorViewModel _refrigerator;

  bool _foldAll = true;

  List<List<TemporaryFood>> categoryFoods = [];
  List<bool> _foldCategory = [];

  @override
  Widget build(BuildContext context) {
    _refrigerator = Get.find();

    for (int i = 0; i < categories.length; i++) {
      categoryFoods.add(_refrigerator.myFoodsViewModel.value.sortByCategory(
          _refrigerator.myFoodsViewModel.value.foods!, categories[i]));

      _foldCategory.add(true);
    }

    return Column(
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
                      for (int i = 0; i < categories.length; i++) {
                        _foldCategory[i] = _foldAll;
                      }
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
          height: deviceHeight - 250,
          child: ListView(
            children: [
              FoodSections(
                  title: categories[0],
                  isFold: _foldCategory[0],
                  onPressed: () {
                    setState(() {
                      _foldCategory[0] = !_foldCategory[0];
                      _foldAll = checkAllFold();
                    });
                  },
                  foods: categoryFoods[0]),
              FoodSections(
                  title: categories[1],
                  isFold: _foldCategory[1],
                  onPressed: () {
                    setState(() {
                      _foldCategory[1] = !_foldCategory[1];
                      _foldAll = checkAllFold();
                    });
                  },
                  foods: categoryFoods[1]),
              FoodSections(
                  title: categories[2],
                  isFold: _foldCategory[2],
                  onPressed: () {
                    setState(() {
                      _foldCategory[2] = !_foldCategory[2];
                      _foldAll = checkAllFold();
                    });
                  },
                  foods: categoryFoods[2]),
              FoodSections(
                  title: categories[3],
                  isFold: _foldCategory[3],
                  onPressed: () {
                    setState(() {
                      _foldCategory[3] = !_foldCategory[3];
                      _foldAll = checkAllFold();
                    });
                  },
                  foods: categoryFoods[3]),
              FoodSections(
                  title: categories[4],
                  isFold: _foldCategory[4],
                  onPressed: () {
                    setState(() {
                      _foldCategory[4] = !_foldCategory[4];
                      _foldAll = checkAllFold();
                    });
                  },
                  foods: categoryFoods[4]),
              FoodSections(
                  title: categories[5],
                  isFold: _foldCategory[5],
                  onPressed: () {
                    setState(() {
                      _foldCategory[5] = !_foldCategory[5];
                      _foldAll = checkAllFold();
                    });
                  },
                  foods: categoryFoods[5]),
              FoodSections(
                  title: categories[6],
                  isFold: _foldCategory[6],
                  onPressed: () {
                    setState(() {
                      _foldCategory[6] = !_foldCategory[6];
                      _foldAll = checkAllFold();
                    });
                  },
                  foods: categoryFoods[6]),
              FoodSections(
                  title: categories[7],
                  isFold: _foldCategory[7],
                  onPressed: () {
                    setState(() {
                      _foldCategory[7] = !_foldCategory[7];
                      _foldAll = checkAllFold();
                    });
                  },
                  foods: categoryFoods[7]),
              FoodSections(
                  title: categories[8],
                  isFold: _foldCategory[8],
                  onPressed: () {
                    setState(() {
                      _foldCategory[8] = !_foldCategory[8];
                      _foldAll = checkAllFold();
                    });
                  },
                  foods: categoryFoods[8]),
              FoodSections(
                  title: categories[9],
                  isFold: _foldCategory[9],
                  onPressed: () {
                    setState(() {
                      _foldCategory[9] = !_foldCategory[9];
                      _foldAll = checkAllFold();
                    });
                  },
                  foods: categoryFoods[9]),
              FoodSections(
                  title: categories[10],
                  isFold: _foldCategory[10],
                  onPressed: () {
                    setState(() {
                      _foldCategory[10] = !_foldCategory[10];
                      _foldAll = checkAllFold();
                    });
                  },
                  foods: categoryFoods[10]),
              FoodSections(
                  title: categories[11],
                  isFold: _foldCategory[11],
                  onPressed: () {
                    setState(() {
                      _foldCategory[11] = !_foldCategory[11];
                      _foldAll = checkAllFold();
                    });
                  },
                  foods: categoryFoods[11]),
            ],
          ),
        ),
      ],
    );
  }

  bool checkAllFold() {
    bool result = true;

    for (int i = 0; i < categories.length; i++) {
      result = result && _foldCategory[i];
    }

    return result;
  }
}

class ShowInShelfLife extends StatelessWidget {
  const ShowInShelfLife({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('유통기한별 보기'));
  }
}
