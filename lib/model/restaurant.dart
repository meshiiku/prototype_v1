class Restaurant {
  final String name;
  final double lat;
  final double lng;
  final String id;
  String? open;
  String? logoImage;
  String? genre;
  String? catchMessage;

  Restaurant({
    required this.name,
    required this.lat,
    required this.lng,
    required this.id,
    this.logoImage,
    this.open,
    this.genre,
    this.catchMessage,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['name'],
      lat: (json['lat']),
      lng: (json['lng']),
      logoImage: json["logo_image"],
      id: json["id"],
      open: json["open"],
      genre: json["genre"]["name"],
      catchMessage: json["genre"]["catch"],
    );
  }
}
