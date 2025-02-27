import "package:prototype_v1/model/restaurant.dart";
import "package:prototype_v1/model/user.dart";

class Post {
  Restaurant restaurant; //飲食店の名前
  User author; //投稿主
  String? mainText; //本文
  String image; // 画像

  Post({required this.restaurant, required this.author, required this.image});
}
