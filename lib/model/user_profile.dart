class UserProfile {
  String username; // ユーザー名
  List<String> hashtags; // ハッシュタグ
  String? profileImage;

  UserProfile({
    required this.username,
    required this.hashtags,
    this.profileImage,
  });
}
