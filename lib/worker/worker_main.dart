import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class WorkerMain extends StatefulWidget {
  const WorkerMain({super.key});

  @override
  _WorkerMainState createState() => _WorkerMainState();
}

class _WorkerMainState extends State<WorkerMain> {
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Dashboard'),
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                ListTile(
                  title: const Text('Current Location'),
                  subtitle: Text(
                      'Lat: ${_currentPosition!.latitude}, Long: ${_currentPosition!.longitude}'),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Garbage Collection Tasks'),
                  // Replace with actual task fetching and management
                  subtitle: const Text('Task 1: Collect garbage from Main St.'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement the functionality to mark the task as complete
                  },
                  child: const Text('Mark as Complete'),
                ),
              ],
            ),
    );
  }
}
