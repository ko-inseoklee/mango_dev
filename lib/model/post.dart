import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/model/user.dart';

class PostList{
  late List<Post> posts;
}

class Post {
  late String postID;
  late int state; // 0: 나눔중, 1: 거래중, 2: 거래완료
  late Timestamp registTime;
  late String subtitle;

  late User owner;
  late String ownerID;
  late List<String> ownerFriendList;

  late Food foods;

  Post.init() {
    this.postID = '';
    this.state = 0;
    this.registTime = Timestamp.now();
    this.subtitle = '나눔합니다';
    this.foods = Food.init();
    this.ownerID = '';
    this.ownerFriendList = [];
  }

  Post.fromSnapshot(Map<String, dynamic> post)
      : postID = post['postID'],
        state = post['state'],
        registTime = post['registTime'],
        subtitle = post['subtitle'],
        ownerID = post['ownerID'],
        ownerFriendList = post['ownerFriendList'];

// Post.fromSnapshot(DocumentSnapshot snapshot)
//     : postID = snapshot.get('postID'),
//       state = snapshot.get('state'),
//       registTime = snapshot.get('registTime'),
//       subtitle = snapshot.get('subtitle'),
//       ownerID = snapshot.get('ownerID'),
//       ownerFriendList = List.from(snapshot.get('ownerFriendList'));
}
