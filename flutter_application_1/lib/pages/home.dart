import 'package:flutter/material.dart';
import 'add.dart';
import 'map.dart';
import 'details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geo Journal – List'),
        actions: []
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
    if(result == true){
    }
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
