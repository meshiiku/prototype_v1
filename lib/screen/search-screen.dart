import "package:app_settings/app_settings.dart";
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:flutter_map_animations/flutter_map_animations.dart";
import "package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart";
import "package:geolocator/geolocator.dart";
import "package:latlong2/latlong.dart";
import "package:modal_bottom_sheet/modal_bottom_sheet.dart";
import "package:prototype_v1/model/restaurant.dart";
import "package:prototype_v1/service/hotpepper-api-client.dart";

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  LatLng? _currentPosition;
  final LatLng _defaultPosition = const LatLng(
    43.062087,
    141.354404,
  ); //札幌市をデフォルト座標として使用
  List<Restaurant> restaurants = [];

  // マップのアニメーション設定
  late final _animatedMapController = AnimatedMapController(vsync: this);

  // 現在地を更新する関数
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
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  List<Marker> buildRestaurantMarkers() {
    return [
      ...restaurants.map(
        (shop) => Marker(
          width: 40,
          height: 40,
          point: LatLng(shop.lat, shop.lng),
          child: CircleAvatar(
            radius: 20,
            child: CircleAvatar(
              radius: 19,
              backgroundImage:
                  shop.logo_image != null
                      ? NetworkImage(shop.logo_image!)
                      : null,
            ),
          ),
        ),
      ),
    ];
  }

  Marker buildLocationMarker() {
    return Marker(
      width: 20,
      height: 20,
      point: _currentPosition ?? _defaultPosition,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.blue, blurRadius: 6)],
        ),
        child: Container(
          margin: EdgeInsets.all(2),
          width: 5,
          height: 5,
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: _defaultPosition, //初期位置
              initialZoom: 10.0,
            ),
            mapController: _animatedMapController.mapController,
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),

              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  builder: (context, marker) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.orange, blurRadius: 20),
                        ],
                      ),
                      child: Center(child: Text(marker.length.toString())),
                    );
                  },
                  markers: buildRestaurantMarkers(),
                ),
              ),
              MarkerLayer(markers: [buildLocationMarker()]),
            ],
          ),
          // コピーライト表示（必要）
          // 参考： https://www.openstreetmap.org/copyright/ja
          const Align(
            alignment: Alignment.bottomLeft,
            child: SafeArea(
              child: const Padding(
                padding: EdgeInsets.all(7),
                child: Text(
                  "©︎ OpenStreetMap contributors",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).scaffoldBackgroundColor.withAlpha(0x50),
                      blurRadius: 9,
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    hintText: "検索する",
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () async {
              await _updateLocationInfo();
              // 更新できたら現在地にフォーカス
              if (_currentPosition != null) {
                _animatedMapController.centerOnPoint(_currentPosition!);

                final fetched_shops = await fetchShops(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                );

                setState(() => restaurants = fetched_shops);
              }
            },
            child: const Icon(Icons.gps_fixed),
          ),
        ],
      ),
    );
  }
}
