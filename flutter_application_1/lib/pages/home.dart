import 'package:flutter/material.dart';
import 'add.dart';
import 'map.dart';
import 'details.dart';
import '/models/geo_note.dart';
import '/services/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Future<List<GeoNotes>> _notes;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _notes = ApiService.instance.getGeoNotes();
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
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
    await Navigator.pushNamed(context, AddGeoNotePage.routeName);
    if(!mounted) return;
    setState(_reload);
  }
    Future<void> _openDetails() async {
    await Navigator.pushNamed(context, DetailsPage.routeName);
    if(!mounted) return;
    setState(_reload);
  }
    Future<void> _openMap() async {
    await Navigator.pushNamed(context, MapPage.routeName);
    if(!mounted) return;
    setState(_reload);
  }
}
