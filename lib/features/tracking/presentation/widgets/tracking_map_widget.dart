import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/config/theme.dart';
import '../../../../core/service/location_service.dart';
import '../../../../core/service/web_location_service.dart';
import '../../data/models/customer_visit_model.dart';
import '../../data/models/location_model.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/config/theme.dart';

import '../../data/models/customer_visit_model.dart';
import '../../data/models/location_model.dart';

class TrackingMapWidget extends StatefulWidget {
  final List<LocationModel> locations;
  final List<CustomerVisitModel> visits;
  final bool showCurrentLocation;

  const TrackingMapWidget({
    Key? key,
    required this.locations,
    required this.visits,
    this.showCurrentLocation = true,
  }) : super(key: key);

  @override
  State<TrackingMapWidget> createState() => _TrackingMapWidgetState();
}

class _TrackingMapWidgetState extends State<TrackingMapWidget> {
  late MapController _mapController;
  LatLng? _currentLocation;
  bool _isLoadingLocation = true;
  double _currentZoom = 13.0;
  LatLng _centerPoint = const LatLng(36.191111, 44.009167); // Default to Erbil, Kurdistan

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    if (widget.showCurrentLocation) {
      _getCurrentLocation();
    } else {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      LatLng? location;

      if (kIsWeb) {
        // Use web-specific location service
        location = await WebLocationService.getCurrentLocation();
      } else {
        // Use mobile location service
        location = await LocationService.getCurrentLocation();
      }

      setState(() {
        _currentLocation = location;
        _isLoadingLocation = false;

        // If current location is available, move map to it
        if (_currentLocation != null) {
          _centerPoint = _currentLocation!;
          _currentZoom = 14.0;
          // Move map in the next frame to ensure controller is ready
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _mapController.move(_centerPoint, _currentZoom);
          });
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });
      debugPrint('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate center of map
    if (widget.locations.isNotEmpty) {
      // Center on the path if we have locations
      double sumLat = 0;
      double sumLng = 0;

      for (var location in widget.locations) {
        sumLat += location.latitude;
        sumLng += location.longitude;
      }

      _centerPoint = LatLng(sumLat / widget.locations.length, sumLng / widget.locations.length);
      _currentZoom = 13.0;
    } else if (widget.visits.isNotEmpty) {
      // Center on visits if no locations
      double sumLat = 0;
      double sumLng = 0;

      for (var visit in widget.visits) {
        sumLat += visit.latitude;
        sumLng += visit.longitude;
      }

      _centerPoint = LatLng(sumLat / widget.visits.length, sumLng / widget.visits.length);
      _currentZoom = 13.0;
    } else if (_currentLocation != null) {
      // Center on current location
      _centerPoint = _currentLocation!;
      _currentZoom = 14.0;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _centerPoint,
              initialZoom: _currentZoom,
              minZoom: 5.0,
              maxZoom: 18.0,
            ),
            children: [
              // Base map layer
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.trackitnow.app',
              ),

              // Path polyline from location points
              if (widget.locations.length > 1)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: widget.locations
                          .map((loc) => LatLng(loc.latitude, loc.longitude))
                          .toList(),
                      color: AppTheme.secondaryColor,
                      strokeWidth: 4.0,
                    ),
                  ],
                ),

              // Location point markers (small)
              MarkerLayer(
                markers: widget.locations.map((location) {
                  return Marker(
                    point: LatLng(location.latitude, location.longitude),
                    width: 15.0,
                    height: 15.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor.withOpacity(0.7),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  );
                }).toList(),
              ),

              // Customer visit markers (larger)
              MarkerLayer(
                markers: widget.visits.map((visit) {
                  return Marker(
                    point: LatLng(visit.latitude, visit.longitude),
                    width: 40.0,
                    height: 40.0,
                    child: GestureDetector(
                      onTap: () => _showVisitDetails(visit),
                      child: Container(
                        decoration: BoxDecoration(
                          color: visit.invoiceMade ? Colors.green : Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.store,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              // Current location marker
              if (_currentLocation != null && widget.showCurrentLocation)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation!,
                      width: 40.0,
                      height: 40.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Loading indicator
          if (_isLoadingLocation)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'دۆزینەوەی شوێن',
                      style: TextStyle(fontSize: 12, color: AppTheme.primaryColor),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
            ),

          // Map controls
          Positioned(
            right: 16,
            bottom: 16,
            child: Column(
              children: [
                // Current location button
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: _getCurrentLocation,
                  child: Icon(
                    Icons.my_location,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                // Zoom in button
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      _currentZoom = _currentZoom + 1;
                    });
                    _mapController.move(_centerPoint, _currentZoom);
                  },
                  child: Icon(
                    Icons.add,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                // Zoom out button
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      _currentZoom = _currentZoom - 1;
                    });
                    _mapController.move(_centerPoint, _currentZoom);
                  },
                  child: Icon(
                    Icons.remove,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Legend at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.black.withOpacity(0.7),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'سەردانەکان: ${widget.visits.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        _buildLegendItem(Colors.green, 'پسوولە هەیە'),
                        const SizedBox(width: 8),
                        _buildLegendItem(Colors.red, 'پسوولە نییە'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  void _showVisitDetails(CustomerVisitModel visit) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(visit.customerName),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('بەروار: ${_formatDateTime(visit.visitDate)}'),
              const SizedBox(height: 8),
              Text('تێبینی: ${visit.feedback.isEmpty ? 'هیچ' : visit.feedback}'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('پسوولە: '),
                  if (visit.invoiceMade)
                    const Icon(Icons.check_circle, color: Colors.green)
                  else
                    const Icon(Icons.cancel, color: Colors.red),
                ],
              ),
              const SizedBox(height: 8),
              Text('ناسنامەی سەردان: ${visit.visitID}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('باشە'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}