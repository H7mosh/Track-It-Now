import 'dart:html' as html;
import 'package:flutter/foundation.dart';

class PermissionService {
  // Request location permission for web
  static Future<bool> requestLocationPermission() async {
    if (kIsWeb) {
      try {
        // Request location permission on web
        final permission = await html.window.navigator.permissions?.query({
          'name': 'geolocation',
        });

        if (permission?.state == 'granted') {
          return true;
        } else if (permission?.state == 'prompt') {
          // Will trigger the permission prompt
          return _promptLocationPermission();
        } else {
          return false;
        }
      } catch (e) {
        debugPrint('Error requesting location permission: $e');
        // Fallback to trying to get position which will trigger the permission dialog
        return _promptLocationPermission();
      }
    } else {
      // For non-web, this should be handled by the geolocator package
      return true;
    }
  }

  // Prompt for location permission by trying to get position
  static Future<bool> _promptLocationPermission() async {
    try {
      // This will trigger the browser's permission dialog
      await html.window.navigator.geolocation.getCurrentPosition();
      return true;
    } catch (e) {
      debugPrint('Error prompting for location: $e');
      return false;
    }
  }
}