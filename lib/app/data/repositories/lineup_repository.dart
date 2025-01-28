// lib/app/data/repositories/lineup_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:livescore_plus/app/data/models/line_up/lineup_model.dart';

class LineupRepository {
  static const String _baseUrl =
      'https://free-api-live-football-data.p.rapidapi.com';
  static const String _apiKey =
      'cc36001cc0msh42e85ca9ad77f06p17e194jsn9119edc970ff';
  static const String _apiHost = 'free-api-live-football-data.p.rapidapi.com';

  final Map<String, String> _headers = {
    'x-rapidapi-host': _apiHost,
    'x-rapidapi-key': _apiKey,
  };

  Future<LineupResponse> getHomeLineup(String eventId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/football-get-hometeam-lineup?eventid=$eventId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return LineupResponse.fromJson(data);
      } else {
        throw Exception(
            'Failed to load home lineup. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching home lineup: $e');
    }
  }

  Future<LineupResponse> getAwayLineup(String eventId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/football-get-awayteam-lineup?eventid=$eventId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return LineupResponse.fromJson(data);
      } else {
        throw Exception(
            'Failed to load away lineup. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching away lineup: $e');
    }
  }
}
