class UserProfile {
  String user_id; // ユーザー名
  List<String> hashtags; // ハッシュタグ
  String? display_name;
  String? profileImage;

  UserProfile({
    required this.user_id,
    required this.hashtags,
    this.profileImage,
    this.display_name,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      user_id: json["user_id"],
      hashtags: List<String>.from(json["hashtags"]),
      profileImage: json["profile_image"],
      display_name: json["display_name"],
    );
  }
}
