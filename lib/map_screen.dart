import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class OpenStreetMapExample extends StatefulWidget {
  final String? locationName; // Accept a string argument
  // final Position pos

  OpenStreetMapExample({required this.locationName}); // Constructor to accept the string argument

  @override
  _OpenStreetMapExampleState createState() => _OpenStreetMapExampleState();
}

class _OpenStreetMapExampleState extends State<OpenStreetMapExample> {
  late MapController _mapController;
  LatLng _currentPosition = LatLng(37.7749, -122.4194); // Default: San Francisco
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _startLocationRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  // Simulate dynamic location updates every 10 seconds
  void _startLocationRefresh() {
    _refreshTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {
        _currentPosition = LatLng(
          _currentPosition.latitude + 0.001, // Simulated movement
          _currentPosition.longitude + 0.001,
        );
      });
      _mapController.move(_currentPosition, _mapController.zoom);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("OpenStreetMap Example")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Location: ${widget.locationName}', // Display the passed string argument
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // SizedBox(height: 8),
                // TextField(
                //   decoration: InputDecoration(
                //     labelText: "Latitude",
                //     border: OutlineInputBorder(),
                //   ),
                //   keyboardType: TextInputType.number,
                //   onChanged: (value) {
                //     setState(() {
                //       _currentPosition = LatLng(
                //         double.tryParse(value) ?? _currentPosition.latitude,
                //         _currentPosition.longitude,
                //       );
                //     });
                //     _mapController.move(_currentPosition, _mapController.zoom);
                //   },
                // ),
                // SizedBox(height: 8),
                // TextField(
                //   decoration: InputDecoration(
                //     labelText: "Longitude",
                //     border: OutlineInputBorder(),
                //   ),
                //   keyboardType: TextInputType.number,
                //   onChanged: (value) {
                //     setState(() {
                //       _currentPosition = LatLng(
                //         _currentPosition.latitude,
                //         double.tryParse(value) ?? _currentPosition.longitude,
                //       );
                //     });
                //     _mapController.move(_currentPosition, _mapController.zoom);
                //   },
                // ),
              ],
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: _currentPosition,
                zoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                  // attributionBuilder: (_) {
                  //   return Text("© OpenStreetMap contributors");
                  // },
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _currentPosition,
                      builder: (ctx) => Container(
                        child: Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
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