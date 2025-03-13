import 'dart:async';
import 'dart:js' as js;
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
/// A location service for getting the user's current location in a web browser
class WebLocationService {
  /// Get the current location using the browser's geolocation API
  static Future<LatLng?> getCurrentLocation() async {
    // This function only works on the web platform
    if (!kIsWeb) return null;

    final completer = Completer<LatLng?>();

    try {
      if (js.context.hasProperty('navigator') &&
          js.context['navigator'].hasProperty('geolocation')) {

        js.context['navigator']['geolocation'].callMethod('getCurrentPosition', [
          js.allowInterop((position) {
            final lat = position['coords']['latitude'] as double;
            final lng = position['coords']['longitude'] as double;
            completer.complete(LatLng(lat, lng));
          }),
          js.allowInterop((error) {
            debugPrint('Error getting location: ${error['code']}, ${error['message']}');
            completer.complete(null);
          }),
          // Options object
          js.JsObject.jsify({
            'enableHighAccuracy': true,
            'timeout': 10000, // 10 seconds
            'maximumAge': 0, // Don't use cached position
          }),
        ]);
      } else {
        debugPrint('Geolocation is not supported in this browser');
        completer.complete(null);
      }
    } catch (e) {
      debugPrint('Exception while getting location: $e');
      completer.complete(null);
    }

    return completer.future;
  }
}