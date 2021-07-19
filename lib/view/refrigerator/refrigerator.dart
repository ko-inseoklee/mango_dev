import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/color.dart';
import 'package:mangodevelopment/view/widget/foodSections.dart';
import 'package:mangodevelopment/viewModel/categoryController.dart';
import 'package:mangodevelopment/viewModel/foodViewModel.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';
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
    // _currentUser = Get.find();
    _refrigerator = Get.find();

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

  List<TemporaryFood> _refrigerationFoods = [];
  List<TemporaryFood> _frozenFoods = [];
  List<TemporaryFood> _roomTempFoods = [];

  bool _foldAll = true;
  bool _foldRefrigerator = true;
  bool _foldFrozen = true;
  bool _foldRoomTemp = true;

  bool isSelected = true;
  List<String> _tempFoodsID = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _refrigerator = Get.find();

    _refrigerator.myFoodsViewModel.value
        .loadFoodsByStoreType(_refrigerator.refID, 0)
        .then((value) => _refrigerationFoods = value);
    _refrigerator.myFoodsViewModel.value
        .loadFoodsByStoreType(_refrigerator.refID, 1)
        .then((value) => _frozenFoods = value);
    _refrigerator.myFoodsViewModel.value
        .loadFoodsByStoreType(_refrigerator.refID, 2)
        .then((value) => _roomTempFoods = value);

    return Column(
      children: [
        Container(
            height: 50,
            child: isSelected ? unSelectedWidget() : selectedWidget()),
        Container(
          height: deviceHeight - 250,
          child: ListView(
            children: [
              // GetX<FoodSectionsController>(
              //     init: refrigeratorSectionController.change(
              //         title: '냉장',
              //         isFold: _foldRefrigerator,
              //         isSelected: isSelected,
              //         onPressed: () {
              //           refrigeratorSectionController
              //                   .foodSections.value.isFold =
              //               !refrigeratorSectionController
              //                   .foodSections.value.isFold;
              //           print(refrigeratorSectionController
              //               .foodSections.value.isFold);
              //           _foldAll = checkAllFold();
              //         },
              //         onSelectParam: (String value) {
              //           selectFoods(value);
              //         },
              //         foods: _frozenFoods),
              //     builder: (_) {
              //       return _.foodSections();
              //     }),
              FoodSections(
                  title: '냉장',
                  isFold: _foldRefrigerator,
                  isSelected: isSelected,
                  onPressed: () {
                    setState(() {
                      _foldRefrigerator = !_foldRefrigerator;
                      _foldAll = checkAllFold();
                    });
                  },
                  onSelectParam: (String value) {
                    selectFoods(value);
                  },
                  foods: _refrigerationFoods),
              FoodSections(
                  title: '냉동',
                  isFold: _foldFrozen,
                  isSelected: isSelected,
                  onPressed: () {
                    setState(() {
                      _foldFrozen = !_foldFrozen;
                      _foldAll = checkAllFold();
                    });
                  },
                  onSelectParam: (String value) {
                    selectFoods(value);
                  },
                  foods: _frozenFoods),
              FoodSections(
                  title: '실온',
                  isFold: _foldRoomTemp,
                  isSelected: isSelected,
                  onPressed: () {
                    setState(() {
                      _foldRoomTemp = !_foldRoomTemp;
                      _foldAll = checkAllFold();
                    });
                  },
                  onSelectParam: (String value) {
                    selectFoods(value);
                  },
                  foods: _roomTempFoods),
            ],
          ),
        ),
      ],
    );
  }

  Widget unSelectedWidget() {
    return Row(
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
            onPressed: () {
              setState(() {
                _foldAll = false;
                _foldRefrigerator = false;
                _foldFrozen = false;
                _foldRoomTemp = false;
                isSelected = !isSelected;
              });
            },
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
    );
  }

  Widget selectedWidget() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          child: Text(
            '선택 ${_tempFoodsID.length}개',
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: MangoDisabledColorDark),
          ),
        ),
        Spacer(),
        TextButton(
          onPressed: () {
            setState(() {});
          },
          child: Text(
            '수정',
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: MangoDisabledColorDark),
          ),
        ),
        TextButton(
          onPressed: () async {
            await _refrigerator.deleteFoods(_tempFoodsID);
            await _refrigerator.loadFoods();
            setState(() {
              _tempFoodsID.clear();
              _foldAll = true;
              _foldRefrigerator = true;
              _foldFrozen = true;
              _foldRoomTemp = true;
              isSelected = !isSelected;
            });
          },
          child: Text(
            '삭제',
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: MangoDisabledColorDark),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _tempFoodsID.clear();
              isSelected = !isSelected;
            });
          },
          child: Text(
            '취소',
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: MangoDisabledColorDark),
          ),
        ),
      ],
    );
  }

  bool checkAllFold() {
    return _foldRefrigerator && _foldRoomTemp && _foldFrozen;
  }

  void selectFoods(String value) {
    if (!_tempFoodsID.contains(value)) {
      setState(() {
        _tempFoodsID.add(value);
      });
    } else {
      setState(() {
        _tempFoodsID.remove(value);
      });
    }
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

  List<TemporaryFood> c1Foods = [];
  List<TemporaryFood> c2Foods = [];
  List<TemporaryFood> c3Foods = [];
  List<TemporaryFood> c4Foods = [];
  List<TemporaryFood> c5Foods = [];
  List<TemporaryFood> c6Foods = [];
  List<TemporaryFood> c7Foods = [];
  List<TemporaryFood> c8Foods = [];
  List<TemporaryFood> c9Foods = [];
  List<TemporaryFood> c10Foods = [];
  List<TemporaryFood> c11Foods = [];
  List<TemporaryFood> c0Foods = [];

  @override
  Widget build(BuildContext context) {
    _refrigerator = Get.find();

    _refrigerator.myFoodsViewModel.value
        .loadFoodsByCategory(_refrigerator.refID, categories[0])
        .then((value) => c0Foods = value);
    _refrigerator.myFoodsViewModel.value
        .loadFoodsByCategory(_refrigerator.refID, categories[1])
        .then((value) => c1Foods = value);
    _refrigerator.myFoodsViewModel.value
        .loadFoodsByCategory(_refrigerator.refID, categories[2])
        .then((value) => c2Foods = value);
    _refrigerator.myFoodsViewModel.value
        .loadFoodsByCategory(_refrigerator.refID, categories[3])
        .then((value) => c3Foods = value);
    _refrigerator.myFoodsViewModel.value
        .loadFoodsByCategory(_refrigerator.refID, categories[4])
        .then((value) => c4Foods = value);
    _refrigerator.myFoodsViewModel.value
        .loadFoodsByCategory(_refrigerator.refID, categories[5])
        .then((value) => c5Foods = value);
    _refrigerator.myFoodsViewModel.value
        .loadFoodsByCategory(_refrigerator.refID, categories[6])
        .then((value) => c6Foods = value);
    _refrigerator.myFoodsViewModel.value
        .loadFoodsByCategory(_refrigerator.refID, categories[7])
        .then((value) => c7Foods = value);
    _refrigerator.myFoodsViewModel.value
        .loadFoodsByCategory(_refrigerator.refID, categories[8])
        .then((value) => c8Foods = value);
    _refrigerator.myFoodsViewModel.value
        .loadFoodsByCategory(_refrigerator.refID, categories[9])
        .then((value) => c9Foods = value);
    _refrigerator.myFoodsViewModel.value
        .loadFoodsByCategory(_refrigerator.refID, categories[10])
        .then((value) => c10Foods = value);
    _refrigerator.myFoodsViewModel.value
        .loadFoodsByCategory(_refrigerator.refID, categories[11])
        .then((value) => c11Foods = value);

    for (int i = 0; i < categories.length; i++) {
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
              // FoodSections(
              //     title: categories[0],
              //     isFold: _foldCategory[0],
              //     onPressed: () {
              //       setState(() {
              //         _foldCategory[0] = !_foldCategory[0];
              //         _foldAll = checkAllFold();
              //       });
              //     },
              //     onSelectParam: (String value) {
              //       print(value);
              //     },
              //     foods: c0Foods),
              // FoodSections(
              //     title: categories[1],
              //     isFold: _foldCategory[1],
              //     onPressed: () {
              //       setState(() {
              //         _foldCategory[1] = !_foldCategory[1];
              //         _foldAll = checkAllFold();
              //       });
              //     },
              //     onSelectParam: (String value) {
              //       print(value);
              //     },
              //     foods: c1Foods),
              // FoodSections(
              //     title: categories[2],
              //     isFold: _foldCategory[2],
              //     onPressed: () {
              //       setState(() {
              //         _foldCategory[2] = !_foldCategory[2];
              //         _foldAll = checkAllFold();
              //       });
              //     },
              //     onSelectParam: (String value) {
              //       print(value);
              //     },
              //     foods: c2Foods),
              // FoodSections(
              //     title: categories[3],
              //     isFold: _foldCategory[3],
              //     onPressed: () {
              //       setState(() {
              //         _foldCategory[3] = !_foldCategory[3];
              //         _foldAll = checkAllFold();
              //       });
              //     },
              //     onSelectParam: (String value) {
              //       print(value);
              //     },
              //     foods: c3Foods),
              // FoodSections(
              //     title: categories[4],
              //     isFold: _foldCategory[4],
              //     onPressed: () {
              //       setState(() {
              //         _foldCategory[4] = !_foldCategory[4];
              //         _foldAll = checkAllFold();
              //       });
              //     },
              //     onSelectParam: (String value) {
              //       print(value);
              //     },
              //     foods: c4Foods),
              // FoodSections(
              //     title: categories[5],
              //     isFold: _foldCategory[5],
              //     onPressed: () {
              //       setState(() {
              //         _foldCategory[5] = !_foldCategory[5];
              //         _foldAll = checkAllFold();
              //       });
              //     },
              //     onSelectParam: (String value) {
              //       print(value);
              //     },
              //     foods: c5Foods),
              // FoodSections(
              //     title: categories[6],
              //     isFold: _foldCategory[6],
              //     onPressed: () {
              //       setState(() {
              //         _foldCategory[6] = !_foldCategory[6];
              //         _foldAll = checkAllFold();
              //       });
              //     },
              //     onSelectParam: (String value) {
              //       print(value);
              //     },
              //     foods: c6Foods),
              // FoodSections(
              //     title: categories[7],
              //     isFold: _foldCategory[7],
              //     onPressed: () {
              //       setState(() {
              //         _foldCategory[7] = !_foldCategory[7];
              //         _foldAll = checkAllFold();
              //       });
              //     },
              //     onSelectParam: (String value) {
              //       print(value);
              //     },
              //     foods: c7Foods),
              // FoodSections(
              //     title: categories[8],
              //     isFold: _foldCategory[8],
              //     onPressed: () {
              //       setState(() {
              //         _foldCategory[8] = !_foldCategory[8];
              //         _foldAll = checkAllFold();
              //       });
              //     },
              //     onSelectParam: (String value) {
              //       print(value);
              //     },
              //     foods: c8Foods),
              // FoodSections(
              //     title: categories[9],
              //     isFold: _foldCategory[9],
              //     onPressed: () {
              //       setState(() {
              //         _foldCategory[9] = !_foldCategory[9];
              //         _foldAll = checkAllFold();
              //       });
              //     },
              //     onSelectParam: (String value) {
              //       print(value);
              //     },
              //     foods: c9Foods),
              // FoodSections(
              //     title: categories[10],
              //     isFold: _foldCategory[10],
              //     onPressed: () {
              //       setState(() {
              //         _foldCategory[10] = !_foldCategory[10];
              //         _foldAll = checkAllFold();
              //       });
              //     },
              //     onSelectParam: (String value) {
              //       print(value);
              //     },
              //     foods: c10Foods),
              // FoodSections(
              //     title: categories[11],
              //     isFold: _foldCategory[11],
              //     onPressed: () {
              //       setState(() {
              //         _foldCategory[11] = !_foldCategory[11];
              //         _foldAll = checkAllFold();
              //       });
              //     },
              //     onSelectParam: (String value) {
              //       print(value);
              //     },
              //     foods: c11Foods),
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
