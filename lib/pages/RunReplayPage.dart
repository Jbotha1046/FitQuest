import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RunReplayPage extends StatelessWidget {
  final dynamic runData;

  RunReplayPage({required this.runData});

  @override
  Widget build(BuildContext context) {
    // Debugging: Print the route data
    print("Route data: ${runData['route']}");

    // Validate and parse route data
    if (runData['route'] == null || runData['route'].isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Run Replay'),
        ),
        body: Center(child: Text('No valid route data available.')),
      );
    }

    final List<LatLng> route = (runData['route'] as List<dynamic>?)
        ?.map((point) {
      if (point is Map<String, dynamic>) {
        final lat = point['latitude'];
        final lng = point['longitude'];
        if (lat is num && lng is num) {
          return LatLng(lat.toDouble(), lng.toDouble());
        }
      }
      return null; // Exclude invalid points
    })
        .where((point) => point != null) // Remove null points
        .cast<LatLng>()
        .toList() ??
        [];

    // Debugging: Print the parsed route
    print("Parsed route: $route");

    // If the route is empty after filtering
    if (route.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Run Replay'),
        ),
        body: Center(child: Text('No valid route points available.')),
      );
    }

    // Create the polyline
    final polyline = Polyline(
      polylineId: PolylineId('replay'),
      color: Colors.blue,
      width: 4,
      points: route,
    );

    // Calculate bounds to fit the polyline
    LatLngBounds bounds;
    if (route.length == 1) {
      bounds = LatLngBounds(
        southwest: route.first,
        northeast: route.first,
      );
    } else {
      final latitudes = route.map((point) => point.latitude).toList();
      final longitudes = route.map((point) => point.longitude).toList();

      bounds = LatLngBounds(
        southwest: LatLng(latitudes.reduce((a, b) => a < b ? a : b),
            longitudes.reduce((a, b) => a < b ? a : b)),
        northeast: LatLng(latitudes.reduce((a, b) => a > b ? a : b),
            longitudes.reduce((a, b) => a > b ? a : b)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Run Replay'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: route.first,
          zoom: 15,
        ),
        mapType: MapType.normal,
        polylines: {polyline},
        onMapCreated: (GoogleMapController controller) {
          // Animate camera to fit bounds
          Future.delayed(Duration(milliseconds: 100), () {
            controller.animateCamera(
              CameraUpdate.newLatLngBounds(bounds, 50),
            );
          });
        },
      ),
    );
  }
}
