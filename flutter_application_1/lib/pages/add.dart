import 'package:flutter/material.dart';

class AddGeoNotePage extends StatefulWidget {
  const AddGeoNotePage({super.key});

  static const routeName = '/add';

  @override
  State<AddGeoNotePage> createState() => _AddGeoNotePage();
}

class _AddGeoNotePage extends State<AddGeoNotePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Geo note'),
      ),
    );
  }
  
}
