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


  late Future<List<String>> ownerFriendList;

  late Food foods;

  Post.init() {
    this.postID = '';
    this.state = 0;
    this.registTime = DateTime.now();
    this.subtitle = '나눔합니다 :)';
    this.foods = Food.init();
    this.ownerFriendList = loadFriendList(owner.userID);

  }

  Post.fromSnapshot(DocumentSnapshot snapshot)
      : postID = snapshot.get('postID'),
        state = snapshot.get('state'),
        registTime = snapshot.get('registTime'),
        subtitle = snapshot.get('subtitle'),
        ownerFriendList = snapshot.get('ownerFriendList');

  Future<List<String>> loadFriendList(String userID) async {
    var data = await FirebaseFirestore.instance
        .collection('user')
        .doc(userID)
        .collection('FriendList')
        .get();

    List<String> _list = [];

    data.docs.forEach((element) {
      _list.add(element.get('userID'));
    });

    return _list;
  }
}
