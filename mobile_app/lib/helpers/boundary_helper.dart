import 'dart:convert';
import 'dart:developer';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class BoundaryHelper {
  static Future<List<List<LatLng>>> getBoundaryPoints(String query) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&polygon_geojson=1&polygon_threshold=0.005&limit=1');

    try {
      // User-Agent is required by Nominatim
      final response = await http.get(url, headers: {
        'User-Agent': 'NicolasGnarrApp/1.0',
      });

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        if (data.isNotEmpty) {
          final geojson = data[0]['geojson'];
          final type = geojson['type'];
          final coordinates = geojson['coordinates'];

          List<List<LatLng>> polygons = [];

          if (type == 'Polygon') {
            // Polygon: [ [ [lon, lat], ... ] ]
            for (var ring in coordinates) {
              List<LatLng> points = [];
              for (var point in ring) {
                // GeoJSON is [lon, lat]
                points.add(LatLng(point[1].toDouble(), point[0].toDouble()));
              }
              polygons.add(points);
            }
          } else if (type == 'MultiPolygon') {
            // MultiPolygon: [ [ [ [lon, lat], ... ] ], ... ]
            for (var polygon in coordinates) {
              for (var ring in polygon) {
                List<LatLng> points = [];
                for (var point in ring) {
                  points.add(LatLng(point[1].toDouble(), point[0].toDouble()));
                }
                polygons.add(points);
              }
            }
          }
          return polygons;
        }
      }
    } catch (e) {
      log('Error fetching boundary: $e');
    }
    return [];
  }
}
