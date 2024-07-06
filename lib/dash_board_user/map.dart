import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:login/services/map_service.dart';
// Import your payment page

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  bool _isLocationEnabled = false;

  // Instantiate FirestoreService
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don't continue.
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, don't continue.
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, don't continue.
      return;
    }

    // When we reach here, permissions are granted and we can get the location.
    _isLocationEnabled = true;
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    // Update user location in Firestore
    if (_isLocationEnabled) {
      await _firestoreService.updateUserLocation(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      // Navigate back to payment page after updating location
      Navigator.pop(context, _currentPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Current Location'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _isLocationEnabled ? _getCurrentLocation : null,
            child: Text('Get Current Location'),
          ),
          if (_currentPosition != null)
            Expanded(
              child: GoogleMap(
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: _currentPosition!,
                  zoom: 14.0,
                ),
                markers: _currentPosition != null
                    ? {
                        Marker(
                          markerId: MarkerId('currentLocation'),
                          position: _currentPosition!,
                        ),
                      }
                    : {},
              ),
            ),
        ],
      ),
    );
  }
}
