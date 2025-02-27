import "package:app_settings/app_settings.dart";
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:flutter_map_animations/flutter_map_animations.dart";
import "package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart";
import "package:geolocator/geolocator.dart";
import "package:latlong2/latlong.dart";
import "package:modal_bottom_sheet/modal_bottom_sheet.dart";
import "package:prototype_v1/components/osm_copyright.dart";
import "package:prototype_v1/model/restaurant.dart";
import "package:prototype_v1/service/hotpepper-api-client.dart";
import "package:prototype_v1/state.dart";

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
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
        currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // 現在地を更新して、フォーカスする。
  void _updateLocationInfoThenFocus() async {
    await _updateLocationInfo();
    if (currentPosition != null) {
      await _animatedMapController.centerOnPoint(
        currentPosition!,
        zoom: 16,
        duration: Duration(seconds: 1),
      );
    }
  }

  // 現在地を更新して、フォーカスする。
  void _updateLocationInfoThenFocusNoDelay() async {
    await _updateLocationInfo();
    if (currentPosition != null) {
      await _animatedMapController.centerOnPoint(
        currentPosition!,
        zoom: 16,
        duration: Duration(seconds: 0),
      );
    }
  }

  // 飲食店のリストを受け取りマーカーをビルドする
  List<Marker> buildRestaurantMarkers(List<Restaurant> restaurants) {
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

  // 現在地マーカーのビルド
  Marker buildCurrentLocationMarker() {
    // 現在地がわからなければ表示しない
    if (currentPosition == null)
      return Marker(point: _defaultPosition, child: Container());
    return Marker(
      width: 20,
      height: 20,
      point: currentPosition ?? _defaultPosition,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.blue, blurRadius: 6)],
        ),
        child: Container(
          margin: const EdgeInsets.all(2),
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

  // 上の検索バー
  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(9),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).scaffoldBackgroundColor.withAlpha(0x50),
              blurRadius: 9,
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            filled: true,
            hintText: "検索する",
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  // 検索バーしたのサジェスト（簡易検索）
  Widget buildSuggestSearch() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        itemBuilder:
            (context, index) => Padding(
              padding: const EdgeInsets.only(left: 9.0),
              child: Container(
                width: 100,
                child: Center(child: Text("#data")),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
            ),
        scrollDirection: Axis.horizontal,

        itemCount: 10,
      ),
    );
  }

  @override
  void initState() {
    if (currentPosition == null) {
      _updateLocationInfoThenFocus();
    } else
      _updateLocationInfoThenFocusNoDelay();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: _defaultPosition, //初期位置
              initialZoom: 12.0,
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
                  markers: buildRestaurantMarkers(restaurants),
                ),
              ),
              MarkerLayer(markers: [buildCurrentLocationMarker()]),
            ],
          ),

          // コピーライト表示（必要）
          // 参考： https://www.openstreetmap.org/copyright/ja
          const OSMCopyRightWidget(),
          SafeArea(
            child: Column(children: [buildSearchBar(), buildSuggestSearch()]),
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
              if (currentPosition != null) {
                _animatedMapController.centerOnPoint(currentPosition!);

                final fetched_shops = await fetchShops(
                  currentPosition!.latitude,
                  currentPosition!.longitude,
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
