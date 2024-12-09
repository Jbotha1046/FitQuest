import 'package:fit_quest/pages/Home.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'local_database.dart'; // Import the LocalDatabaseHelper
import 'user_run.dart'; //

class RunTrackingScreen extends StatefulWidget {
  @override
  _RunTrackingScreenState createState() => _RunTrackingScreenState();
}

class _RunTrackingScreenState extends State<RunTrackingScreen> {
  GoogleMapController? _mapController;
  List<LatLng> _routePoints = [];
  double _distance = 0.0;
  Position? _lastPosition;
  bool _isRunning = false;
  Timer? _timer;
  Duration _duration = Duration();
  String _formattedTime = "00:00:00";

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  // Request location permission
  void _requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showMessage('Location services are disabled');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showMessage('Location permissions are required');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showMessage('Location permissions are permanently denied');
      return;
    }

    _startRun();
  }

  void _startRun() {
    setState(() {
      _isRunning = true;
      _routePoints.clear();
      _distance = 0.0;
      _lastPosition = null; // Reset last position
    });

    // Timer for tracking duration
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _duration = _duration + Duration(seconds: 1);
        _formattedTime = _formatDuration(_duration);
      });
    });

    // Position stream
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // Minimum distance to trigger updates
      ),
    ).listen((Position position) {
      if (!mounted) return;

      setState(() {
        // Only calculate distance if there was a previous position
        if (_lastPosition != null) {
          double distanceMoved = Geolocator.distanceBetween(
            _lastPosition!.latitude,
            _lastPosition!.longitude,
            position.latitude,
            position.longitude,
          );

          // Add distance only if it's above a reasonable threshold
          if (distanceMoved > 0.5) {
            _distance += distanceMoved;
            _routePoints.add(LatLng(position.latitude, position.longitude));
          }
        } else {
          // Add the first position to the route points
          _routePoints.add(LatLng(position.latitude, position.longitude));
        }

        _lastPosition = position;

        if (!kIsWeb) {
          _mapController?.animateCamera(
            CameraUpdate.newLatLng(
                LatLng(position.latitude, position.longitude)),
          );
        }
      });
    });
  }

  void _pauseRun() {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
  }

  void _resumeRun() {
    setState(() {
      _isRunning = true;
    });
    _startRun();
  }

  void _endRun() async {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showMessage("No user logged in. Cannot save the run.");
        return;
      }

      // Save to Firestore
      await FirebaseFirestore.instance.collection('runs').add({
        'userId': user.uid,
        'distance': (_distance / 1000).toStringAsFixed(2), // Convert to km
        'duration': _duration.inSeconds,
        'route': _routePoints
            .map((point) => {'latitude': point.latitude, 'longitude': point.longitude})
            .toList(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      _showMessage("Run saved successfully.");
    } catch (e) {
      _showMessage("Failed to save run: $e");
      print("Error: $e");
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }


  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Run Tracking'),
      ),
      body: Column(
        children: [
          Expanded(
            child: kIsWeb
                ? Center(child: Text("Map is not supported in web mode"))
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _lastPosition != null
                          ? LatLng(
                              _lastPosition!.latitude, _lastPosition!.longitude)
                          : LatLng(
                              37.7749, -122.4194), // Fallback to San Francisco
                      zoom: 12.0,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    polylines: {
                      Polyline(
                        polylineId: PolylineId('route'),
                        points: _routePoints,
                        color: Colors.blue,
                        width: 5,
                      ),
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text("Distance: ${(_distance / 1000).toStringAsFixed(2)} km"),
                Text("Time: $_formattedTime"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _isRunning ? _pauseRun : _resumeRun,
                      child: Text(_isRunning ? "Pause" : "Resume"),
                    ),
                    ElevatedButton(
                      onPressed: _isRunning ? _endRun : null,
                      child: Text("End Run"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
