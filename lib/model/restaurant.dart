class Restaurant {
  final String name;
  final double lat;
  final double lng;
  String? logo_image;

  Restaurant({
    required this.name,
    required this.lat,
    required this.lng,
    this.logo_image,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['name'],
      lat: (json['lat']),
      lng: (json['lng']),
      logo_image: json["logo_image"],
    );
  }
}
