import "dart:math";

import "package:dio/dio.dart";
import "package:flutter/cupertino.dart";
import "package:prototype_v1/env.dart";
import "package:prototype_v1/model/user.dart";
import "package:prototype_v1/saves/jwt.dart";

class BackendAPIClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Env.backendBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  BackendAPIClient() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final jwtToken = await getJWTToken();
          if (jwtToken != null) {
            options.headers["Authorization"] = "Bearer $jwtToken";
          }
          return handler.next(options);
        },
        onError: (options, handler) async {
          // Todo: エラー時に再度ログインする機能
          if (options.response?.statusCode == 401) {
            // 認証失敗（jwtトークンが切れているかも）
            debugPrint("logout");
          }
          return handler.next((options));
        },
      ),
    );
  }

  // 単純なgetリクエスト
  Future<Response> getData(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // 匿名アカウントでログインする
  Future<String?> loginAsAnonymous() async {
    final response = await getData("/account/anonymous");
    if (response.data != null) {
      final jwt = response.data;
      saveJWTToken(jwt);
      return jwt;
    }
    return null;
  }

  // 認証されていればOKが返ってくる。
  Future<String?> getCheck() async {
    final response = await getData("/account/auth/check");
    return response.data;
  }

  // user_id(hoge12032103)からユーザー情報を取得する
  Future<User> getUserInfoById(String user_id) async {
    final response = await getData("/account/users/" + user_id);
    final user = User.fromJson(response.data);
    return user;
  }

  // ユーザーを検索する
  Future<List<User>?> searchUser(String query) async {
    final response = await getData("/account/users/search?q=$query");
    final List<dynamic> json = response.data;
    final users = json.map((item) => User.fromJson(item));
    return users.toList();
  }

  // ランダムなラーメンの画像を持ってくる
  static String randomRamenImageUrl() {
    return "${Env.backendBaseUrl}/static/random_ramens/${Random().nextInt(11) + 1}.jpeg";
  }

  // ランダムなラーメンの画像を持ってくる
  static String randomRamenIconUrl() {
    return "${Env.backendBaseUrl}/static/random_icons/${Random().nextInt(5) + 1}.png";
  }

  // chatのセッションを作る
  Future<String> createChatSession() async {
    final response = await getData("/agent/chat/create");
    final sessionId = response.data["session_id"];

    return sessionId;
  }

  Future<String> sendChat(String sessionId, String message) async {
    final response = await getData(
      "/agent/chat/$sessionId/chat?message=$message",
    );
    return response.data["message"];
  }
}
