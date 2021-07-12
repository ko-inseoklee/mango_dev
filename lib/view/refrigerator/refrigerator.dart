import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/color.dart';
import 'package:mangodevelopment/viewModel/categoryController.dart';
import 'package:mangodevelopment/viewModel/myFoodsViewModel.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';
import 'package:mangodevelopment/viewModel/tempUserViewModel.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';
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
                        print(
                            _refrigerator.myFoodsViewModel.value.foods!.length);
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

class ShowInOnce extends StatelessWidget {
  late RefrigeratorViewModel _refrigerator;

  ShowInOnce({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _refrigerator = Get.find();

    print(_refrigerator.myFoodsViewModel.value.foods!.length);

    return Container(
        padding: EdgeInsets.all(8.0),
        child: GridView.count(
          childAspectRatio: 50 / 60,
          crossAxisCount: 3,
          children:
              _buildFoodCards(_refrigerator.myFoodsViewModel.value.foods!),
        ));
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
