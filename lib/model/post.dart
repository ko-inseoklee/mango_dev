import 'package:cloud_firestore/cloud_firestore.dart';
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
    DocumentSnapshot owner,
  )   : postID = post['postID'],
        state = post['state'],
        registTime = post['registTime'],
        foods = Food.init(),
        // foods = Food.fromSnapshot(food),
        subtitle = post['subtitle'],
        ownerID = post['ownerID'],
        owner = User.fromSnapshot(owner),
        ownerFriendList = post['ownerFriendList'].cast<String>();

// Post.fromSnapshot(DocumentSnapshot snapshot)
//     : postID = snapshot.get('postID'),
//       state = snapshot.get('state'),
//       registTime = snapshot.get('registTime'),
//       subtitle = snapshot.get('subtitle'),
//       ownerID = snapshot.get('ownerID'),
//       ownerFriendList = List.from(snapshot.get('ownerFriendList'));

}
