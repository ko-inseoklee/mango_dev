import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/widgetController/showFoodViewModel.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';
import 'package:mangodevelopment/view/refrigerator/modifyFoods.dart';
import 'package:mangodevelopment/view/refrigerator/recipe.dart';
import 'package:mangodevelopment/view/widget/mangoDivider.dart';
import 'package:mangodevelopment/view/widget/refrigerator/foodSections.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';
import '../../color.dart';

List<String> canModifyFoods = [];

class RefrigeratorPage extends StatefulWidget {
  String title;
  RefrigeratorPage({Key? key, required String title}) : title = title;

  @override
  _RefrigeratorPageState createState() => _RefrigeratorPageState();
}

class _RefrigeratorPageState extends State<RefrigeratorPage> {
  late UserViewModel user;

  ShowFoodsController controller = Get.put(new ShowFoodsController());

  RefrigeratorViewModel refrigerator = Get.put(new RefrigeratorViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = Get.find<UserViewModel>();
    refrigerator.loadRefID(rID: user.user.value.refrigeratorID).then((value) {
      controller.loadAllFoods(rID: user.user.value.refrigeratorID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Obx(() {
            return Container(
              height: ScreenUtil().setHeight(465),
              child: ListView(
                children: [secondTab()],
              ),
            );
          })
          // Container(
          //     height: ScreenUtil().setHeight(43),
          //     child: Column(
          //       children: [
          //         Row(
          //           children: [
          //             Obx(() {
          //               return tabView(title: '유통기한별 보기', idx: 0);
          //             }),
          //             Obx(() {
          //               return tabView(title: '한눈에 보기', idx: 1);
          //             }),
          //             Obx(() {
          //               return tabView(title: '카테고리별 보기', idx: 2);
          //             }),
          //           ],
          //         ),
          //       ],
          //     )),
          // Obx(() {
          //   return controller.foods.value.currentTab == 0
          //       ? Container(
          //           width: ScreenUtil().setWidth(375),
          //           height: ScreenUtil().setHeight(106),
          //           decoration: BoxDecoration(
          //             image: DecorationImage(
          //               fit: BoxFit.fill,
          //               image:
          //                   AssetImage('images/prototype/recommandRecipe.png'),
          //             ),
          //           ),
          //           child: TextButton(
          //             onPressed: () {
          //               Get.to(() => RecipePage(title: '레시피 페이지'));
          //             },
          //             child: Text(''),
          //           ),
          //         )
          //       : SizedBox(
          //           height: ScreenUtil().setHeight(0.1),
          //         );
          // }),
          // Container(
          //   height: ScreenUtil().setHeight(41),
          //   child: Obx(() {
          //     return !controller.foods.value.isModify
          //         ? Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             children: [
          //               Container(
          //                 padding: EdgeInsets.only(left: 8.0),
          //                 child: Obx(() {
          //                   return Text(
          //                     '전체 ${controller.foods.value.foodsLength} 개',
          //                     style: Theme.of(context).textTheme.subtitle1,
          //                   );
          //                 }),
          //               ),
          //               Spacer(),
          //               Container(
          //                   child: TextButton(
          //                 onPressed: () {
          //                   controller.foldAll(
          //                       storeType: controller.foods.value.currentTab,
          //                       isFold: controller.foods.value.allFold);
          //                 },
          //                 child: Obx(() {
          //                   return controller.foods.value.allFold
          //                       ? Text('모두 펼치기',
          //                           style:
          //                               Theme.of(context).textTheme.subtitle2)
          //                       : Text('모두 접기',
          //                           style:
          //                               Theme.of(context).textTheme.subtitle2);
          //                 }),
          //               )),
          //               Container(
          //                   padding: EdgeInsets.symmetric(horizontal: 8.0),
          //                   child: TextButton(
          //                       onPressed: () {
          //                         controller.changeIsModify();
          //                         controller.foldAll(
          //                             storeType:
          //                                 controller.foods.value.currentTab,
          //                             isFold: true);
          //                       },
          //                       child: Text('선택',
          //                           style: Theme.of(context)
          //                               .textTheme
          //                               .subtitle2))),
          //             ],
          //           )
          //         : Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             children: [
          //               Container(
          //                 padding: EdgeInsets.only(left: 8.0),
          //                 child: Obx(() {
          //                   return Text(
          //                     '선택 ${controller.foods.value.canModifyFoods.length} 개',
          //                     style: Theme.of(context).textTheme.subtitle1,
          //                   );
          //                 }),
          //               ),
          //               Spacer(),
          //               Container(
          //                   child: TextButton(
          //                 onPressed: () async {
          //                   await controller
          //                       .deleteFood(
          //                           rID: refrigerator.ref.value.rID,
          //                           foods:
          //                               controller.foods.value.canModifyFoods)
          //                       .then((value) {
          //                     controller.clearCanModify();
          //                   });
          //                   await controller
          //                       .getFoodsLength(rID: refrigerator.ref.value.rID)
          //                       .then((value) {
          //                     controller.changeIsModify();
          //                     controller.foldAll(
          //                         storeType: controller.foods.value.currentTab,
          //                         isFold: controller.foods.value.allFold);
          //                   });
          //                 },
          //                 child: Text('삭제',
          //                     style: Theme.of(context).textTheme.subtitle2),
          //               )),
          //               Container(
          //                   child: TextButton(
          //                 onPressed: () {
          //                   controller.changeIdx();
          //                   Get.to(ModifyFoods(title: '품목 수정'),
          //                       arguments:
          //                           controller.foods.value.canModifyFoods);
          //                 },
          //                 child: Text('수정',
          //                     style: Theme.of(context).textTheme.subtitle2),
          //               )),
          //               Container(
          //                   padding: EdgeInsets.symmetric(horizontal: 8.0),
          //                   child: TextButton(
          //                       onPressed: () {
          //                         controller.changeIsModify();
          //                         controller.clearCanModify();
          //                       },
          //                       child: Text('취소',
          //                           style: Theme.of(context)
          //                               .textTheme
          //                               .subtitle2))),
          //             ],
          //           );
          //   }),
          // ),
          // MangoDivider(),
          // Obx(() {
          //   return controller.foods.value.currentTab == 0
          //       ? Container(
          //           height: ScreenUtil().setHeight(465),
          //           child: ListView(
          //             children: [
          //               Obx(() {
          //                 return firstTab();
          //               })
          //             ],
          //           ),
          //         )
          //       : Container(
          //           height: ScreenUtil().setHeight(575),
          //           child: ListView(
          //             children: [
          //               Obx(() {
          //                 return controller.foods.value.currentTab == 1
          //                     ? secondTab()
          //                     : thirdTab();
          //               })
          //             ],
          //           ),
          //         );
          // })
        ],
      ),
    );
  }

  Widget tabView({required String title, required int idx}) {
    return Container(
      width: ScreenUtil().setWidth(125),
      height: ScreenUtil().setHeight(43),
      decoration: BoxDecoration(
          border: Border(
              bottom: controller.foods.value.currentTab == idx
                  ? BorderSide(color: Orange700)
                  : BorderSide.none)),
      child: TextButton(
        child: Text(
          title,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
              color: controller.foods.value.currentTab == idx
                  ? Orange700
                  : MangoDisabledColor),
        ),
        onPressed: () {
          controller.changeViewMode(viewMode: idx);
        },
      ),
    );
  }

  Widget firstTab() {
    return Column(children: [
      TestFoodSections(title: '유통기한 경과', idx: 20),
      TestFoodSections(title: '유통기한 7일 이내', idx: 15),
      TestFoodSections(
          title: '구매일로부터 ${user.user.value.roomTempAlarm}일 경과 - 실온', idx: 18),
      TestFoodSections(
          title: '구매일로부터 ${user.user.value.refrigerationAlarm}일 경과 - 냉장',
          idx: 16),
      TestFoodSections(
          title: '구매일로부터 ${user.user.value.frozenAlarm}일 경과 - 냉동', idx: 17),
      TestFoodSections(title: '안심 Zone', idx: 19),
    ]);
  }

  Widget secondTab() {
    return Column(
      children: [
        TestFoodSections(title: '냉장', idx: 0),
        TestFoodSections(title: '냉동', idx: 1),
        TestFoodSections(title: '실온', idx: 2)
      ],
    );
  }

  Widget thirdTab() {
    return Column(
      children: [
        TestFoodSections(title: '과일', idx: 3),
        TestFoodSections(title: '채소', idx: 4),
        TestFoodSections(title: '우유/유제품', idx: 5),
        TestFoodSections(title: '수산물', idx: 6),
        TestFoodSections(title: '곡물', idx: 7),
        TestFoodSections(title: '조미료/양념', idx: 8),
        TestFoodSections(title: '육류', idx: 9),
        TestFoodSections(title: '냉장/냉동식품', idx: 10),
        TestFoodSections(title: '베이커리', idx: 11),
        TestFoodSections(title: '김치/반찬', idx: 12),
        TestFoodSections(title: '즉석식품', idx: 13),
        TestFoodSections(title: '물/음료', idx: 14)
      ],
    );
  }
}
