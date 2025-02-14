import 'package:flutter/material.dart';

import '../../constants/location_service.dart';

class LocationCheckScreen extends StatefulWidget {
  const LocationCheckScreen({super.key});

  @override
  _LocationCheckScreenState createState() => _LocationCheckScreenState();
}

class _LocationCheckScreenState extends State<LocationCheckScreen> {
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _checkLocation();
  }

  Future<void> _checkLocation() async {
    bool serviceEnabled = await _locationService.checkLocationService();
    bool permissionsGranted = await _locationService.checkPermissions(context);

    if (!serviceEnabled || !permissionsGranted) {
      _showLocationAlert();
    } else {
      final locationData = await _locationService.getLocation(context);
      print(
          "Current Location: ${locationData?.latitude}, ${locationData?.longitude}");
    }
  }

  void _showLocationAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Location Required'),
        content: const Text(
            'Location services are required to use this app. Please enable location.'),
        actions: [
          TextButton(
            onPressed: () {
              _checkLocation();
            },
            child: const Text('Retry'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Exit App'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location Check')),
      body: const Center(
        child: Text('Checking location...'),
      ),
    );
  }
}
