class ApiConstants {
  // Base URL
  static const String baseUrl = 'http://hajijafar-001-site1.anytempurl.com';

  // Auth Endpoints
  static const String signIn = '/api/Auth/signin';
  static const String searchUsers = '/api/Auth/search';

  // Customer Visits Endpoints
  static const String getCustomerVisitsByUser = '/api/CustomerVisits/byUser';
  static const String addCustomerVisit = '/api/CustomerVisits';
  static const String getCustomerVisit = '/api/CustomerVisits';
  static const String getUsersWithVisits = '/api/Auth/users';

  // User Activity Tracking
  static const String getUserActivity = '/api/UserActivity/activity';

  // Error messages in Kurdish
  static const String connectionError = 'ناتوانێت پەیوەندی بکرێت';
  static const String authError = 'کێشەی پشتڕاستکردنەوە هەیە';
  static const String generalError = 'هەڵەیەک ڕوویدا';
}