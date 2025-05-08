import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class OpenWeatherMap extends StatefulWidget {
  const OpenWeatherMap({super.key});

  @override
  State<OpenWeatherMap> createState() => _OpenWeatherMapState();
}

class _OpenWeatherMapState extends State<OpenWeatherMap> {

  final String apiKey = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rain Map'),
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
        actions: [
          IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () {
          // Refresh map data
        },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
          children: [
            Icon(Icons.water_drop, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              "Precipitation Map", 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(16),
              ),
              child: Text("Live"),
            )
          ],
            ),
          ),
        ),
          ),
          Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 2),
            )
          ],
            ),
            child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(7.8731, 80.7718), // Example: Sri Lanka
            initialZoom: 6.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
              userAgentPackageName: 'com.example.rainmap',
            ),
            TileLayer(
              urlTemplate: 'https://tile.openweathermap.org/map/precipitation_new/{z}/{x}/{y}.png?appid=$apiKey',
              userAgentPackageName: 'com.example.rainmap',
              tileProvider: NetworkTileProvider(),
              // opacity: 0.6,
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
  }
