import "package:dio/dio.dart";
import "package:prototype_v1/saves/jwt.dart";

class BackendAPIClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://192.168.1.191:3000",
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

  // ログインする
  Future<String?> loginAsDummy() async {
    final response = await getData("/account/dummy");
    if (response.data != null) {
      final jwt = response.data;
      saveJWTToken(jwt);
      return jwt;
    }
    return null;
  }
}
