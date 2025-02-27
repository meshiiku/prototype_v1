import "package:shared_preferences/shared_preferences.dart";

// JWTトークンを保存する
Future<void> saveJWTToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("jwt_token", token);
}

// JWTトークンを取得する
Future<String?> getJWTToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("jwt_token");
}

// JWTトークンをリセットする
Future<void> resetJWTToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove("jwt_token");
}
