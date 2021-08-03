import 'package:get/get.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/model/user.dart';

class Post {
  late String postID;
  late int state; // 0: 나눔중, 1: 거래중, 2: 거래완료
  late DateTime registTime;
  var subtitle;

  late User owner;
  late User taker;
  late Food foods;

  Post.init() {
    this.postID = '0';
    this.state = 0;
    this.registTime = DateTime.now();
    this.subtitle = '나눔합니다 :)';
    this.owner = User.init(
      userID: '',
      creationTime: DateTime.now(),
      refrigeratorID: '1',
      refrigerationAlarm: 0,
      isRefShelf: false,
      frozenAlarm: 0,
      isFroShelf: false,
      roomTempAlarm: 0,
      isRTShelf: false,
      lastSignIn: DateTime.now(),
      profileImageReference: '-1',
      userName: '',
      tokens: [],
    );

    this.taker = this.taker = User.init(
      userID: '',
      creationTime: DateTime.now(),
      refrigeratorID: '1',
      refrigerationAlarm: 0,
      isRefShelf: false,
      frozenAlarm: 0,
      isFroShelf: false,
      roomTempAlarm: 0,
      isRTShelf: false,
      lastSignIn: DateTime.now(),
      profileImageReference: '',
      userName: '',
      tokens: [],
    );

    this.foods = Food.init();
  }
}

class localPostList {
  static List<Post> loadPostList() {
    List<Post> Posts = <Post>[
      Post.init(),
    ];

    return Posts;
  }
}
