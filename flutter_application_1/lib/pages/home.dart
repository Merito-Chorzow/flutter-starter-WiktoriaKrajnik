import 'package:flutter/material.dart';
import 'add.dart';
import 'map.dart';
import 'details.dart';
import '/models/geo_note.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Future<List<GeoNotes>> _notes;
  final List<GeoNotes> _internalNotes = [];

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _notes = Future.value(_internalNotes);
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Geo Journal – List'),
        actions: []
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
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("No geo notes added yet."),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: _openAdd, child: const Text("Add your first note")),
                ],
              ),
            );
        }
          return ListView.separated(
            itemCount: notes.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.dateCreated.toLocal().toString()),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openMenu(context),
        child: const Icon(Icons.menu),
      ),
    );
  }
  
  void _openMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:(context){
        return SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 8),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                      Navigator.pop(context);
                      _openAdd();
                    },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Note"),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                      Navigator.pop(context);
                      _openDetails(); 
                    },
                  icon: const Icon(Icons.details),
                  label: const Text("Details"),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                      Navigator.pop(context);
                      _openMap(); 
                    },
                  icon: const Icon(Icons.map),
                  label: const Text("Map"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
    Future<void> _openAdd() async {
    final result = await Navigator.pushNamed(context, AddGeoNotePage.routeName);
    if(!mounted) return;
    if (result is! Map<String, dynamic>) return;

    final newNote = GeoNotes(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: result['title'] as String,
      description: result['description'] as String,
      latitude: (result['lat'] as num).toDouble(),
      longitude: (result['lng'] as num).toDouble(),
      dateCreated: DateTime.parse(result['date'] as String),
    );

    setState(() {
      _internalNotes.add(newNote);
      _reload();
    });
  }
    Future<void> _openDetails() async {
    final result = await Navigator.pushNamed(context, DetailsPage.routeName);
    if(result == true){
    }
  }
    Future<void> _openMap() async {
    final result = await Navigator.pushNamed(context, MapPage.routeName);
    if(result == true){
    }
  }
}
