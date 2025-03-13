import 'customer_visit_model.dart';
import 'location_model.dart';

class DateRange {
  final DateTime start;
  final DateTime end;

  DateRange({
    required this.start,
    required this.end,
  });

  factory DateRange.fromJson(Map<String, dynamic> json) {
    return DateRange(
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
    };
  }
}

class ActivitySummary {
  final int totalLocationsRecorded;
  final int totalCustomerVisits;
  final int visitsWithInvoice;

  ActivitySummary({
    required this.totalLocationsRecorded,
    required this.totalCustomerVisits,
    required this.visitsWithInvoice,
  });

  factory ActivitySummary.fromJson(Map<String, dynamic> json) {
    return ActivitySummary(
      totalLocationsRecorded: json['totalLocationsRecorded'] ?? 0,
      totalCustomerVisits: json['totalCustomerVisits'] ?? 0,
      visitsWithInvoice: json['visitsWithInvoice'] ?? 0,
    );
  }
}

class UserActivityModel {
  final String userName;
  final DateRange dateRange;
  final ActivitySummary summary;
  final List<LocationModel> locations;
  final List<CustomerVisitModel> customerVisits;

  UserActivityModel({
    required this.userName,
    required this.dateRange,
    required this.summary,
    required this.locations,
    required this.customerVisits,
  });

  factory UserActivityModel.fromJson(Map<String, dynamic> json) {
    return UserActivityModel(
      userName: json['userName'],
      dateRange: DateRange.fromJson(json['dateRange']),
      summary: ActivitySummary.fromJson(json['summary']),
      locations: (json['locations'] as List)
          .map((location) => LocationModel.fromJson(location))
          .toList(),
      customerVisits: (json['customerVisits'] as List)
          .map((visit) => CustomerVisitModel.fromJson(visit))
          .toList(),
    );
  }
}