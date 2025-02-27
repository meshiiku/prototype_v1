import "package:app_settings/app_settings.dart";
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:flutter_map_animations/flutter_map_animations.dart";
import "package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart";
import "package:geolocator/geolocator.dart";
import "package:latlong2/latlong.dart";
import "package:modal_bottom_sheet/modal_bottom_sheet.dart";
import "package:prototype_v1/components/osm_copyright.dart";
import "package:prototype_v1/components/user_card.dart";
import "package:prototype_v1/model/post.dart";
import "package:prototype_v1/model/restaurant.dart";
import "package:prototype_v1/model/user.dart";
import "package:prototype_v1/service/backend-api-client.dart";
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
  List<String> tags = [];

  // マップのアニメーション設定
  late final _animatedMapController = AnimatedMapController(
    vsync: this,
    mapController: MapController(),
  );

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
        duration: const Duration(seconds: 1),
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
        duration: const Duration(seconds: 0),
      );
    }
  }

  // モーダル内に表示される飲食店の情報
  List<Widget> buildModalRestaurantInfo(
    BuildContext context,
    Restaurant restaurant,
  ) {
    return [
      Padding(
        padding: const EdgeInsets.all(6),
        child: UserCard(
          profile: User(
            userId: restaurant.name,

            hashtags: ["焼肉", "ガツガツ系", "うどん"],
            profileImage: restaurant.logoImage,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Row(
          children: [
            Icon(
              Icons.people,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            const SizedBox(width: 7),
            const Text("4人が興味を持っています"),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 6, top: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Container(
                  height: 35,
                  decoration: BoxDecoration(
                    color: Theme.of(context).buttonTheme.colorScheme?.onPrimary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(child: Text("友達とメシイク")),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Container(
                  height: 35,
                  decoration: BoxDecoration(
                    color: Theme.of(context).buttonTheme.colorScheme?.onPrimary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 5),
                        Text("イキタイリストに追加"),
                        SizedBox(width: 5),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  // グリッド上に表示される友達がアップロードした写真
  Widget buildFriendsPhoto() {
    // Todo: Postクラスを使って実装する。
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 列数
        crossAxisSpacing: 1, // 列間のスペース
        mainAxisSpacing: 1, // 行間のスペース
      ),
      itemCount: 20,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Card(
              child: AspectRatio(
                aspectRatio: 1,
                child: Image(
                  image: NetworkImage(BackendAPIClient.randomRamenImageUrl()),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    BackendAPIClient.randomRamenIconUrl(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // 飲食店をタップした時に表示されるモーダルの実装
  Widget buildRestaurantModal(BuildContext context, Restaurant restaurant) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              // このお店の情報
              ...buildModalRestaurantInfo(context, restaurant),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              // 友人がこのお店で撮影した写真
              Padding(
                padding: const EdgeInsets.all(5),
                child: buildFriendsPhoto(),
              ),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ],
    );
  }

  // 飲食店のリストを受け取りマーカーをビルドする
  List<Marker> buildRestaurantMarkers(List<Restaurant> restaurants) {
    return [
      ...restaurants.map(
        (restaurant) => Marker(
          width: 40,
          height: 40,
          point: LatLng(restaurant.lat, restaurant.lng),
          child: GestureDetector(
            onTap: () {
              showBarModalBottomSheet(
                context: context,
                enableDrag: true,
                builder: (context) => buildRestaurantModal(context, restaurant),
              );
            },
            child: CircleAvatar(
              radius: 20,
              child: CircleAvatar(
                radius: 19,
                backgroundImage:
                    restaurant.logoImage != null
                        ? NetworkImage(restaurant.logoImage!)
                        : null,
              ),
            ),
          ),
        ),
      ),
    ];
  }

  // 現在地マーカーのビルド
  Marker buildCurrentLocationMarker() {
    // 現在地がわからなければ表示しない
    if (currentPosition == null) {
      return Marker(point: _defaultPosition, child: Container());
    }
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
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 70,
            top: 10,
            bottom: 10,
            right: 10,
          ),
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
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 1,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Material(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Theme.of(context).primaryColor,
              child: InkWell(
                onTap: () {},

                child: Container(
                  width: 50, // ボタンの幅
                  height: 50, // ボタンの高さ
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.smart_toy_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
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
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(9),
                  child: Center(child: Text(tags[index])),
                ),
              ),
            ),
        scrollDirection: Axis.horizontal,

        itemCount: tags.length,
      ),
    );
  }

  @override
  void initState() {
    if (currentPosition == null) {
      _updateLocationInfoThenFocus();
    } else {
      _updateLocationInfoThenFocusNoDelay();
    }
    updateNearRestaurants();
    // TODO: implement initState
    super.initState();
  }

  void updateNearRestaurants() async {
    await _updateLocationInfo();
    // 更新できたら現在地にフォーカス
    if (currentPosition != null) {
      _animatedMapController.centerOnPoint(currentPosition!);

      final fetchedRestaurants = await fetchRestaurants(
        currentPosition!.latitude,
        currentPosition!.longitude,
      );
      tags = [];
      for (var restaurant in fetchedRestaurants) {
        // 見つけたお店のジャンルをtagsに追加する。
        if (restaurant.genre != null) {
          if (!tags.contains(restaurant.genre)) {
            setState(() {
              tags.add(restaurant.genre!);
            });
          }
        }

        continue;
      }
      setState(() => restaurants = fetchedRestaurants);
    }
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
              maxZoom: 17,
              minZoom: 6,
            ),
            mapController: _animatedMapController.mapController,
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),

              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  rotate: true,

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
            onPressed: () {
              updateNearRestaurants();
            },
            child: const Icon(Icons.gps_fixed),
          ),
        ],
      ),
    );
  }
}
