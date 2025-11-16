import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/geo_note.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '/services/api.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  static const routeName = '/map';

  @override
  State<MapPage> createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  late Future<List<GeoNotes>> _notes;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    setState(() {
      _notes = ApiService.instance.getGeoNotes();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Map'),
      ),
      body: FutureBuilder<List<GeoNotes>>(
        future: _notes,
        builder: (context, snapshot) {
          LatLng center = const LatLng(51.5, -0.09);
          List<Marker> markers = [];

          if (snapshot.connectionState == ConnectionState.waiting) {
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final notes = snapshot.data!;
            center = LatLng(notes.first.latitude, notes.first.longitude);
            markers = notes
                .map(
                  (note) => Marker(
                    point: LatLng(note.latitude, note.longitude),
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      child: const Icon(Icons.location_pin, size: 48, color: Colors.red),
                    ),
                  ),
                )
                .toList();
          }

          return Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: center,
                  initialZoom: 10,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  if (markers.isNotEmpty) MarkerLayer(markers: markers),
                ],
              ),
              if (snapshot.connectionState == ConnectionState.waiting)
                const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _reload,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

