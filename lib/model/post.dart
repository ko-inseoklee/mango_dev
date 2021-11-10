import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/model/user.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

class PostList {
  late List<Post> posts;
}

class Post {
  late String postID;
  late int state; // 0: 나눔중, 1: 거래중, 2: 거래완료
  late Timestamp registTime;
  late String subtitle;

  late User owner;

  late List<String> chatList;

  late Food foods;

  Post.init() {
    this.postID = '';
    this.state = 0;
    this.registTime = Timestamp.now();
    this.subtitle = '나눔합니다';
    this.foods = Food.init();
    // this.ownerFriendList = [];
    this.owner = User.init(
        userID: '',
        creationTime: Timestamp.now(),
        refrigeratorID: '',
        refrigerationAlarm: 0,
        isRefShelf: true,
        frozenAlarm: 0,
        isFroShelf: true,
        roomTempAlarm: 0,
        isRTShelf: true,
        lastSignIn: Timestamp.now(),
        profileImageReference: '-1',
        userName: '',
        tokens: '',
        isAlarmOn: true,
        phoneNumber: '',
        chatList: [],
        location: GeoPoint(0,0),
    );
  }

  Post.fromSnapshot(Map<String, dynamic> post, DocumentSnapshot snapshot)
      : postID = post['postID'],
        state = post['state'],
        registTime = post['registTime'],
        foods = Food(
            fId: '',
            rId: '',
            index: 0,
            status: false,
            name: post['foodName'],
            num: post['foodNum'],
            category: post['category'],
            method: 0,
            displayType: false,
            shelfLife: post['shelfLife'].toDate(),
            registrationDay: post['shelfLife'].toDate(),
            alarmDate: DateTime.now(),
            cardStatus: 0),
        // foods = Food.fromSnapshot(food),
        subtitle = post['subtitle'],
        owner = User.fromSnapshot(snapshot);

}
