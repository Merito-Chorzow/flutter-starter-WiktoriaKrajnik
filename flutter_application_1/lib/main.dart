import 'package:flutter/material.dart';
import 'pages/add.dart';
import 'pages/home.dart';
import 'pages/map.dart';
import 'pages/details.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Geo Jurnal",
      theme: ThemeData.light(),
      home: const HomePage(),
      routes: {
        AddGeoNotePage.routeName: (context) => const AddGeoNotePage(),
        MapPage.routeName: (context)=> const MapPage(),
        DetailsPage.routeName: (context) => const DetailsPage(),
      },
    );
  }
}
