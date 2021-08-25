import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/model/post.dart';
import 'package:mangodevelopment/view/trade/friend/friendList.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/trade/location.dart';
import 'package:mangodevelopment/view/tutorial/Home/tutorial.dart';
import 'package:mangodevelopment/view/widget/postCardWidget.dart';
import 'package:mangodevelopment/viewModel/postViewModel.dart';
import 'package:mangodevelopment/viewModel/push_test.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';
import 'Chat/chatList.dart';

class TradePage extends StatefulWidget {
  final String title;

  const TradePage({Key? key, required this.title}) : super(key: key);

  @override
  _TradePageState createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  late List<Post> posts = [];
  late List<Post> myPosts = [];

  late List<Post> searchPosts = [];
  late List<Post> localPosts = [];

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
    localPosts = [];
    _determinePosition().then((value) {
      loadLocalPost(value);
    });
  }

  FirebaseFirestore mango_dev = FirebaseFirestore.instance;

  UserViewModel userViewModelController = Get.find<UserViewModel>();

  @override
  Widget build(BuildContext context) {
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
                Get.to(Location());
              },
              icon: Icon(Icons.notifications_none))
        ],
      ),
      // ignore: unrelated_type_equality_checks
      body: countDocuments(userViewModelController.userID) == 0
          ? Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(Test());
                      },
                      child: Image(
                        image: AssetImage('images/login/logo.png'),
                      ),
                    ),
                    Text(
                      '친구를 추가해서 \n거래를 시작해보세요',
                      textAlign: TextAlign.center,
                    ),
                  ]),
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
                  child: StreamBuilder<QuerySnapshot>(
                    stream:
                        // _search == ''?
                        mango_dev
                            .collection('post')
                            .orderBy('registTime', descending: true)
                            .snapshots(),
                    // : mango_dev
                    //     .collection('post')
                    //     .where('ownerID',
                    //         isEqualTo: userViewModelController
                    //             .user.value.userID)
                    //     .where('foodName', isEqualTo: _search)
                    //     .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      // _search == '' ?
                      // loadPost(); //
                      // : loadSearchPost(_search);

                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (localPosts.isEmpty) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return ListView.separated(
                          itemBuilder: (context, index) {
                            return MangoPostCard(
                              post: localPosts[index],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider();
                          },
                          itemCount: localPosts.length);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void loadPost() async {
    posts = await post.loadPosts();
  }

  void loadLocalPost(Position userLocation) async {
    localPosts = await post.loadLocalPosts(userLocation);
  }

  // void loadMyPost() async {
  //   myPosts = await post.loadMyPosts();
  // }

  // void loadSearchPost(String _search) async {
  //   searchPosts = await post.loadSearchPosts(_search);
  // }

  Future<int> countDocuments(String curr_uid) async {
    print('curr: $curr_uid');
    QuerySnapshot _myDoc = await mango_dev
        .collection('user')
        .doc(curr_uid)
        .collection('FriendList')
        .get();

    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    print('count = ' + _myDocCount.length.toString());
    return _myDocCount.length; // Count of Documents in Collection
  }
}
