class Restaurant {
  final String name;
  final double lat;
  final double lng;
  String? logoImage;

  Restaurant({
    required this.name,
    required this.lat,
    required this.lng,
    this.logoImage,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['name'],
      lat: (json['lat']),
      lng: (json['lng']),
      logoImage: json["logo_image"],
    );
  }
}
