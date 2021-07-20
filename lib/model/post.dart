class Post {
  final String postID;
  final String uid;
  String profileImageRef;

  // String foodID 필요
  final String foodName;
  int num;
  DateTime shelfLife;
  final DateTime registTime;
  String subtitle;

  Post(this.postID, this.uid, String profileImageRef, this.foodName, int num,
      DateTime shelfLife, this.registTime, String subtitle)
      : profileImageRef = profileImageRef,
        num = num,
        shelfLife = shelfLife,
        subtitle = subtitle;
}

class localPostList {
  static List<Post> loadPostList() {
    List<Post> Posts = <Post>[
      Post(
        'random1',
        'c7C6rengEzNjTB0St3hqrObsiCY2',
        '/data/user/0/com.dobby.mangodevelopment.mangodevelopment/cache/image_picker276594650273670702.jpg',
        'Mango',
        3,
        DateTime(20201, 07, 23),
        DateTime(20201, 07, 19, 18, 05),
        '나눔합니다',
      ),
      Post(
        'random2',
        'uYGuIzoPWKNvWxovizq1m3yYQOB3',
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
