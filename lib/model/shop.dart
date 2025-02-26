class Shop {
  final String name;
  final double lat;
  final double lng;
  String? logo_image;

  Shop({
    required this.name,
    required this.lat,
    required this.lng,
    this.logo_image,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      name: json['name'],
      lat: (json['lat']),
      lng: (json['lng']),
      logo_image: json["logo_image"],
    );
  }
}
