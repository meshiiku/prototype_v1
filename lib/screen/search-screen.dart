import "package:app_settings/app_settings.dart";
import "package:flutter/material.dart";
import "package:geolocator/geolocator.dart";

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Position? _currentPosition;
  String _locationMessage = "位置情報：";

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
        _currentPosition = position;
        _locationMessage = '現在位置: ${position.latitude}, ${position.longitude}';
      });
    } catch (e) {
      setState(() {
        _locationMessage = '位置情報の取得に失敗しました: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Geolocator.requestPermission();

    return Scaffold(
      body: Container(child: Text("${_locationMessage}")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _updateLocationInfo();
        },
        child: Icon(Icons.gps_fixed),
      ),
    );
  }
}
