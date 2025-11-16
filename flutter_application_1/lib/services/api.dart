import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/geo_note.dart';

class ApiService {
  ApiService._privateConstructor();
  static final ApiService instance = ApiService._privateConstructor();

  final List<GeoNotes> _store = [];
  
  Future<http.Response> postGeoNote(
    String title,
    String description,
    double lat,
    double lng,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final newnote = GeoNotes(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      description: description,
      latitude: lat,
      longitude: lng,
      dateCreated: DateTime.now(),
    );

    _store.add(newnote);
    
    final body = jsonEncode(newnote.toJson());
    final response = http.Response(body, 201);
    return response;
  }

  Future<List<GeoNotes>> getGeoNotes() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<GeoNotes>.from(_store);

  }

  Future<void> deleteGeoNote(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _store.removeWhere((note) => note.id == id);
  }

    void clear() {
    _store.clear();
  }

  int get count => _store.length;
}

