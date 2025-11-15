import 'package:flutter/material.dart';
import 'package:location/location.dart';

class AddGeoNotePage extends StatefulWidget {
  const AddGeoNotePage({super.key});

  static const routeName = '/add';

  @override
  State<AddGeoNotePage> createState() => _AddGeoNotePage();
}

class _AddGeoNotePage extends State<AddGeoNotePage> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _latCtrl = TextEditingController();
  final _lngCtrl = TextEditingController();
  bool _loading = false;
  double? _lat;
  double? _lng;
  final Location _location = Location();

  Future<void> _getLocation() async {
  setState(() => _loading = true);
  try {
    var serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      final enable = await _location.requestService();
      if (!enable) throw "Localization services are disabled";
    }

    var permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
      if (permission != PermissionStatus.granted) throw "Localization permission denied";
    }

    final loc = await _location.getLocation();
    if (!mounted) return;
    setState(() {
      _lat = loc.latitude;
      _lng = loc.longitude;
      _latCtrl.text = _lat?.toString() ?? '';
      _lngCtrl.text = _lng?.toString() ?? '';
    });
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error downloading localization: $e")),);
  } finally {
    if (mounted) {setState(() => _loading = false);}
  }
}

  Future<void> _submit() async {
    final title = _titleCtrl.text.trim();
    final desc = _descCtrl.text.trim();
    if (title.isEmpty || desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Title and Description cannot be empty")));
      return;
    }
    double? lat = _lat;
    double? lng = _lng;
    if ((lat == null || lng == null) && _latCtrl.text.isNotEmpty && _lngCtrl.text.isNotEmpty) {
      lat = double.tryParse(_latCtrl.text);
      lng = double.tryParse(_lngCtrl.text);
    }
    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Get location or enter valid lat and lng")));
      return;
    }
    final newGeoNote = {
    "title": title,
    "description": desc,
    "lat": lat,
    "lng": lng,
    "date": DateTime.now().toIso8601String(),
    };
    Navigator.pop(context, newGeoNote);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add Geo note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: "Title")),
            TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: "Description"), maxLines: 3),
            const SizedBox(height: 12),
            Row(children: [
              ElevatedButton.icon(onPressed: _loading ? null : _getLocation, icon: const Icon(Icons.gps_fixed), label: const Text("Get current location")),
              const SizedBox(width: 8),
              const Text("or enter manually"),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: TextField(controller: _latCtrl, decoration: const InputDecoration(labelText: "Lat. geogr. (lat)"))),
              const SizedBox(width: 8),
              Expanded(child: TextField(controller: _lngCtrl, decoration: const InputDecoration(labelText: "Lng. geogr. (lng)"))),
            ]),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _loading ? null : _submit, child: _loading ? const CircularProgressIndicator() : const Text('Zapisz')),
          ],
        ),
      ),
    );
  }
  
}
