import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/geo_note.dart';
import '/services/api.dart';


class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  static const routeName = '/details';

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Future<List<GeoNotes>> _notes;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _notes = ApiService.instance.getGeoNotes();
  }

  Future<void> _deleteNote(GeoNotes note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete note"),
        content: Text("Delete '${note.title}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    try {
      await ApiService.instance.deleteGeoNote(note.id);
      setState(() {
        _reload(); 
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error while deleting: $e")),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
    child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Notes details'),
      ),
      body: FutureBuilder<List<GeoNotes>>(
        future: _notes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final notes = snapshot.data ?? [];
          if (notes.isEmpty) {
            return const Center(
              child: Text("No geo notes available."),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12.0),
            itemCount: notes.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final note = notes[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(note.title, style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 8),
                          Text(note.description, style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 8),
                          Text("Created on: ${note.dateCreated.toLocal().toString().split(' ')[0]}",
                            style: const TextStyle( fontSize: 14, fontStyle: FontStyle.italic, color:Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text("Location: ${note.latitude.toStringAsFixed(4)}, ${note.longitude.toStringAsFixed(4)}",
                            style: const TextStyle( fontSize: 14, color:Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                    ),
                      IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteNote(note),
                      ),
                    ],  
                  ),  
                );
              },
            );
          },
        ),
      )
    );
  }
}
