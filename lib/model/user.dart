class User {
  String userId; // ユーザー名
  List<String> hashtags; // ハッシュタグ
  String? displayName;
  String? profileImage;

  User({
    required this.userId,
    required this.hashtags,
    this.profileImage,
    this.displayName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json["user_id"],
      hashtags: List<String>.from(json["hashtags"]),
      profileImage: json["profile_image"],
      displayName: json["display_name"],
    );
  }
}
