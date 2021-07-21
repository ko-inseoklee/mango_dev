import 'package:get/get.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/model/user.dart';

class Post {
  var state; // 0: 나눔중, 1: 거래중, 2: 거래완료
  var registTime;
  var subtitle;

  var owner;
  var taker;
  var foods;

  Post.init() {
    this.state = 0;
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
      profileImageReference: '',
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

    this.foods = TemporaryFood.init();
  }

// Post(int state,
//     this.postID,
//     this.uid,
//     String userName,
//     String profileImageRef,
//     this.foodName,
//     int num,
//     DateTime shelfLife,
//     this.registTime,
//     String subtitle)
//     : userName = userName,
//       state = state,
//       profileImageRef = profileImageRef,
//       num = num,
//       shelfLife = shelfLife,
//       subtitle = subtitle;
}

class localPostList {
  static List<Post> loadPostList() {
    List<Post> Posts = <Post>[
      Post.init(),
      // Post(
      //   0,
      //   'random1',
      //   'c7C6rengEzNjTB0St3hqrObsiCY2',
      //   'inseok',
      //   '/data/user/0/com.dobby.mangodevelopment.mangodevelopment/cache/image_picker276594650273670702.jpg',
      //   'Mango',
      //   3,
      //   DateTime(20201, 07, 23),
      //   DateTime(20201, 07, 19, 18, 05),
      //   '나눔합니다',
      // ),
      Post(
        1,
        'random2',
        'uYGuIzoPWKNvWxovizq1m3yYQOB3',
        'jhyun',
        '-1',
        'Apple',
        1,
        DateTime(20201, 07, 23),
        DateTime(20201, 07, 19, 18, 05),
        '나눔합니다',
      ),
    ];

    return Posts;
  }
}
