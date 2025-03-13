

class CustomerVisitModel {
  final String visitID;
  final String customerName;
  final DateTime visitDate;
  final String feedback;
  final bool invoiceMade;
  final double latitude;
  final double longitude;

  CustomerVisitModel({
    required this.visitID,
    required this.customerName,
    required this.visitDate,
    required this.feedback,
    required this.invoiceMade,
    required this.latitude,
    required this.longitude,
  });

  factory CustomerVisitModel.fromJson(Map<String, dynamic> json) {
    return CustomerVisitModel(
      visitID: json['visitID'],
      customerName: json['customerName'],
      visitDate: DateTime.parse(json['visitDate']),
      feedback: json['feedback'] ?? '',
      invoiceMade: json['invoiceMade'] ?? false,
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'visitID': visitID,
      'customerName': customerName,
      'visitDate': visitDate.toIso8601String(),
      'feedback': feedback,
      'invoiceMade': invoiceMade,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class CustomerVisitDto {
  final String customerID;
  final String userName;
  final String feedback;
  final bool invoiceMade;
  final double latitude;
  final double longitude;

  CustomerVisitDto({
    required this.customerID,
    required this.userName,
    required this.feedback,
    required this.invoiceMade,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerID': customerID,
      'userName': userName,
      'feedback': feedback,
      'invoiceMade': invoiceMade,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}