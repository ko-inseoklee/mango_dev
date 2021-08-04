import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/model/user.dart';

class Post {
  late String postID;
  late int state; // 0: 나눔중, 1: 거래중, 2: 거래완료
  late DateTime registTime;
  late String subtitle;

  late User owner;
  late String ownerID;
  late List<String> ownerFriendList;

  late Food foods;

  Post.init() {
    this.postID = '';
    this.state = 0;
    this.registTime = DateTime.now();
    this.subtitle = '나눔합니다';
    this.foods = Food.init();
    this.ownerID = '';
    this.ownerFriendList = [];
    // this.owner.userID = '';
  }

  Post.fromSnapshot(DocumentSnapshot snapshot)
      : postID = snapshot.get('postID'),
        state = snapshot.get('state'),
        registTime = snapshot.get('registTime'),
        subtitle = snapshot.get('subtitle'),
        ownerID = snapshot.get('ownerID'),
        ownerFriendList = List.from(snapshot.get('ownerFriendList'));
}
