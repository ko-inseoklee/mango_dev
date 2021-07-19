class Post {
  final String uid;
  // String foodID 필요
  final String foodName;
  int num;
  DateTime shelfLife;
  String subtitle;
  final DateTime registTime;

  Post(this.uid, this.foodName, int num, DateTime shelfLife, this.registTime,
      String subtitle)
      : num = num,
        shelfLife = shelfLife,
        subtitle = subtitle;
}

class localPostList {
  static List<Post> loadPostList() {
    List<Post> Posts = <Post>[
      Post(
        'c7C6rengEzNjTB0St3hqrObsiCY2',
        'Mango',
        3,
        DateTime.now(),
        DateTime.now(),
        '나눔합니다',
      ),
      Post(
        'uYGuIzoPWKNvWxovizq1m3yYQOB3',
        'Apple',
        1,
        DateTime.now(),
        DateTime.now(),
        '나눔합니다',
      ),
    ];

    return Posts;
  }
}
