import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/model/post.dart';
import 'package:mangodevelopment/view/trade/addLocation.dart';
import 'package:mangodevelopment/view/trade/friend/friendList.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/trade/myPost.dart';
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
  late GeoPoint deviceLat;

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
    // deviceLat = await Geolocator.getCurrentPosition();
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: '');
    Get.find<postViewModel>().clearPost();
    if (userViewModelController.user.value.location != GeoPoint(0, 0))
      Get.find<postViewModel>()
          .loadLocalPosts(userViewModelController.user.value.location);

    // get device position
    _determinePosition().then((value) {
      deviceLat = GeoPoint(value.latitude, value.longitude);
    });

  }

  FirebaseFirestore mango_dev = FirebaseFirestore.instance;

  UserViewModel userViewModelController = Get.find<UserViewModel>();
  postViewModel postViewModelController = Get.find<postViewModel>();

  @override
  Widget build(BuildContext context) {
    // if (postViewModelController.localPost.length == 0) initState();
    // Get.find<postViewModel>().loadLocalPosts(deviceLat);
    // Get.find<postViewModel>()
    //     .loadLocalPosts(userViewModelController.user.value.location);

    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.person),
        //   onPressed: () {
        //     Get.to(FriendListPage());
        //   },
        // ),
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.to(ChatList());
              },
              icon: Icon(Icons.chat_bubble_outline_outlined)),
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
                        Get.to(addLocationPage(
                          deviceLat: deviceLat,
                        ));
                      },
                      child: Text(
                        '??????????????? ???????????? \n????????? ??????????????????',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]),
            )
          : Obx(() {
              return postViewModelController.localPost.length == 0
                  ? Center(
                      child: Text('????????? ????????? ???????????? ????????????.'),
                    )
                  : Column(
                      children: <Widget>[
                        // Container(
                        //   width: MediaQuery.of(context).size.width,
                        //   color: Colors.grey[100],
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: Text(userViewModelController.user.value.),
                        //   ),
                        // ),

                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: CupertinoSearchTextField(
                        //     controller: _textController,
                        // onSubmitted: (String value) {
                        //   setState(() {
                        //     _search = value;
                        //   });
                        // },
                        // placeholder: '????????? ??????',
                        //   ),
                        // ),
                        Flexible(
                          child: ListView.separated(
                              itemBuilder: (context, index) {
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
                      ],
                    );
            }),
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
    return _myDocCount.length; // Count of Documents in Collection
  }
}
