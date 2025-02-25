import "dart:convert";

import "package:app_settings/app_settings.dart";
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:flutter_map_animations/flutter_map_animations.dart";
import "package:geolocator/geolocator.dart";
import "package:latlong2/latlong.dart";

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  LatLng? _currentPosition;
  final LatLng _defaultPosition = LatLng(43.062087, 141.354404);
  String _locationMessage = "位置情報：";

  // マップのアニメーション設定
  late final _animatedMapController = AnimatedMapController(vsync: this);

  Future<void> _updateLocationInfo() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // リトライ
        // NOTE: Android用...?（未検証）
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // NOTE: IOS「位置情報：しない」の場合（検証済み）
        AppSettings.openAppSettings(type: AppSettingsType.location);
        return;
      }

      // 位置を取得
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _locationMessage = "現在位置: ${position.latitude}, ${position.longitude}";
      });
    } catch (e) {
      setState(() {
        _locationMessage = "位置情報の取得に失敗しました: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Geolocator.requestPermission();

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: _defaultPosition,
              initialZoom: 10.0,
            ),
            mapController: _animatedMapController.mapController,
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),
              MarkerLayer(
                rotate: true,
                markers: [
                  Marker(
                    width: 40,
                    height: 40,
                    point: _currentPosition ?? _defaultPosition,
                    child: CircleAvatar(radius: 22),
                  ),
                ],
              ),
            ],
          ),
          // コピーライト表示
          const Padding(
            padding: EdgeInsets.all(7),
            child: Text(
              "©︎ OpenStreetMap contributors",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _updateLocationInfo();
          // 更新できたら現在地にフォーカス
          if (_currentPosition != null) {
            _animatedMapController.centerOnPoint(_currentPosition!);
          }
        },
        child: Icon(Icons.gps_fixed),
      ),
    );
  }
}
