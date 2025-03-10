import "package:flutter/cupertino.dart";
import 'package:http/http.dart' as http;
import "package:prototype_v1/env.dart";
import 'dart:convert';

import "package:prototype_v1/model/restaurant.dart";

Future<List<Restaurant>> fetchRestaurants(
  double latitude,
  double longitude,
) async {
  var apiKey = Env.apiKey;
  final url =
      'https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=$apiKey&lat=$latitude&lng=$longitude&range=5&format=json&count=30';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    debugPrint(data.toString());
    final List<dynamic> shops = data['results']['shop'];
    return shops.map((shop) => Restaurant.fromJson(shop)).toList();
  } else {
    throw Exception('店舗データの取得に失敗しました');
  }
}
