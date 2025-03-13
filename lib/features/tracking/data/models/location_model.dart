class LocationModel {
  final int id;
  final String nameUser;
  final double latitude;
  final double longitude;
  final DateTime recordedTime;

  LocationModel({
    required this.id,
    required this.nameUser,
    required this.latitude,
    required this.longitude,
    required this.recordedTime,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      nameUser: json['name_user'],
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      recordedTime: DateTime.parse(json['recorded_Time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_user': nameUser,
      'latitude': latitude,
      'longitude': longitude,
      'recorded_Time': recordedTime.toIso8601String(),
    };
  }
}