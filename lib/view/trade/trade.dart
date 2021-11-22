import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/model/post.dart';
import 'package:mangodevelopment/view/trade/addLocation.dart';
import 'package:mangodevelopment/view/trade/friend/friendList.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/trade/googleMap.dart';
import 'package:mangodevelopment/view/trade/location.dart';
import 'package:mangodevelopment/view/tutorial/Home/tutorial.dart';
import 'package:mangodevelopment/view/widget/postCardWidget.dart';
import 'package:mangodevelopment/viewModel/postViewModel.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';
import 'Chat/chatList.dart';

class TradePage extends StatefulWidget {
  final String title;

  const TradePage({Key? key, required this.title}) : super(key: key);

  @override
  _TradePageState createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  late Position deviceLat;

  postViewModel post = Get.put(postViewModel());

  String _search = '';
  late TextEditingController _textController;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    deviceLat = await Geolocator.getCurrentPosition();
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: '');
    Get.find<postViewModel>().clearPost();
    _determinePosition().then((value) {
      Get.find<postViewModel>().loadLocalPosts(deviceLat);
    });
  }

  FirebaseFirestore mango_dev = FirebaseFirestore.instance;

  UserViewModel userViewModelController = Get.find<UserViewModel>();
  postViewModel postViewModelController = Get.find<postViewModel>();

  @override
  Widget build(BuildContext context) {
    // if (postViewModelController.localPost.length == 0) initState();
    // Get.find<postViewModel>().loadLocalPosts(deviceLat);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.person),
          onPressed: () {
            Get.to(FriendListPage());
          },
        ),
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.to(ChatList());
              },
              icon: Icon(Icons.chat_bubble_outline_outlined)),
          IconButton(
              onPressed: () {
                // Get.to(Location());
                Get.to(addLocationPage());
                // Get.to(googleMap());
              },
              icon: Icon(Icons.notifications_none))
        ],
      ),
      // ignore: unrelated_type_equality_checks
      body: userViewModelController.user.value.location == GeoPoint(0, 0)
          ? Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        print('location:' +
                            userViewModelController
                                .user.value.location.longitude
                                .toString());
                        // Get.to(Test());
                      },
                      child: Image(
                        image: AssetImage('images/login/logo.png'),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(addLocationPage());
                      },
                      child: Text(
                        '장소정보를 등록하고 \n거래를 시작해보세요',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]),
            )
          : Obx(() {
              return postViewModelController.localPost.length == 0
                  ? Center(
                      child: Text('주변에 등록된 게시글이 없습니다.'),
                    )
                  : Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CupertinoSearchTextField(
                            controller: _textController,
                            onSubmitted: (String value) {
                              setState(() {
                                _search = value;
                              });
                            },
                            placeholder: '게시글  검색',
                          ),
                        ),
                        Flexible(
                          child: ListView.separated(
                              itemBuilder: (context, index) {
                                // print('length:' + _.localPost.length.toString());
                                return MangoPostCard(
                                    post: postViewModelController
                                        .localPost[index]);
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Divider();
                              },
                              itemCount:
                                  postViewModelController.localPost.length),
                        ),
                        // Flexible(
                        //   child: StreamBuilder<QuerySnapshot>(
                        //     stream:
                        //         // _search == ''?
                        //         mango_dev
                        //             .collection('post')
                        //             .orderBy('registTime', descending: true)
                        //             .snapshots(),
                        //     // : mango_dev
                        //     //     .collection('post')
                        //     //     .where('ownerID',
                        //     //         isEqualTo: userViewModelController
                        //     //             .user.value.userID)
                        //     //     .where('foodName', isEqualTo: _search)
                        //     //     .snapshots(),
                        //     builder:
                        //         (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        //       // _search == '' ?
                        //       // loadPost(); //
                        //       // : loadSearchPost(_search);
                        //
                        //       if (!snapshot.hasData) {
                        //         return Center(
                        //           child: CircularProgressIndicator(),
                        //         );
                        //       }
                        //
                        //       return ListView.separated(
                        //           itemBuilder: (context, index) {
                        //             return GetBuilder<postViewModel>(
                        //               init: postViewModel(),
                        //               builder: (_) {
                        //                 return MangoPostCard(
                        //                     post: _.localPost[index]);
                        //               },
                        //             );
                        //           },
                        //           separatorBuilder:
                        //               (BuildContext context, int index) {
                        //             return Divider();
                        //           },
                        //           itemCount:
                        //               postViewModelController.localPost.length);
                        //     },
                        //   ),
                        // ),
                      ],
                    );
            }),
      // Column(
      //   children: <Widget>[
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: CupertinoSearchTextField(
      //         controller: _textController,
      //         onSubmitted: (String value) {
      //           setState(() {
      //             _search = value;
      //           });
      //         },
      //         placeholder: '게시글  검색',
      //       ),
      //     ),
      //     Flexible(
      //       child: StreamBuilder<QuerySnapshot>(
      //         stream:
      //         // _search == ''?
      //         mango_dev
      //             .collection('post')
      //             .orderBy('registTime', descending: true)
      //             .snapshots(),
      //         // : mango_dev
      //         //     .collection('post')
      //         //     .where('ownerID',
      //         //         isEqualTo: userViewModelController
      //         //             .user.value.userID)
      //         //     .where('foodName', isEqualTo: _search)
      //         //     .snapshots(),
      //         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //           // _search == '' ?
      //           // loadPost(); //
      //           // : loadSearchPost(_search);
      //
      //           if (!snapshot.hasData) {
      //             return Center(
      //               child: CircularProgressIndicator(),
      //             );
      //           }
      //
      //           return ListView.separated(
      //               itemBuilder: (context, index) {
      //                 return GetBuilder<postViewModel>(
      //                   init: postViewModel(),
      //                   builder: (_) {
      //                     return MangoPostCard(post: _.localPost[index]);
      //                   },
      //                 );
      //               },
      //               separatorBuilder: (BuildContext context, int index) {
      //                 return Divider();
      //               },
      //               itemCount: postViewModelController.localPost.length);
      //         },
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  Future<int> countDocuments(String curr_uid) async {
    // print('curr: $curr_uid');
    QuerySnapshot _myDoc = await mango_dev
        .collection('user')
        .doc(curr_uid)
        .collection('FriendList')
        .get();

    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    // print('count = ' + _myDocCount.length.toString());
    return _myDocCount.length; // Count of Documents in Collection
  }
}
