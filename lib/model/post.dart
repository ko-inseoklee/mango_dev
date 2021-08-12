import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
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

  late String ownerID;
  late String ownerName;
  late String profileImageRef;

  late List<String> ownerFriendList;

  late Food foods;

  Post.init() {
    this.postID = '';
    this.state = 0;
    this.registTime = Timestamp.now();
    this.subtitle = '나눔합니다';
    this.foods = Food.init();
    this.ownerID = '';
    this.ownerName = '';
    this.profileImageRef = '-1';
    this.ownerFriendList = [];
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
        friendList: []);
  }

  Post.fromSnapshot(
    Map<String, dynamic> post,
  )   : postID = post['postID'],
        state = post['state'],
        registTime = post['registTime'],
        foods = Food.init(),
        // foods = Food.fromSnapshot(food),
        subtitle = post['subtitle'],
        ownerID = post['ownerID'],
        ownerName = post['ownerName'],
        profileImageRef = post['profileImageRef'],
        ownerFriendList = post['ownerFriendList'].cast<String>(),

        //TODO: owner = User.fromSanpshot
        owner = User.init(
            userID: post['ownerID'],
            creationTime: post['registTime'],
            refrigeratorID: '',
            refrigerationAlarm: 0,
            isRefShelf: false,
            frozenAlarm: 0,
            isFroShelf: false,
            roomTempAlarm: 0,
            isRTShelf: false,
            lastSignIn: Timestamp.now(),
            profileImageReference: post['profileImageRef'],
            userName: post['ownerName'],
            tokens: '',
            friendList: post['ownerFriendList'].cast<String>());


}
