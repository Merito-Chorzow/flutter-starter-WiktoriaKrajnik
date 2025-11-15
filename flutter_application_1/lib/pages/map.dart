import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  static const routeName = '/map';

  @override
  State<MapPage> createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        actions: []
      ),
    );
  }

}
