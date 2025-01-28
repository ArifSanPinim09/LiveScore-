// lib/app/data/repositories/match_stats_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/match_stats/match_stats_model.dart';

class MatchStatsRepository {
  static const String _baseUrl =
      'https://free-api-live-football-data.p.rapidapi.com';
  static const String _apiKey =
      'cc36001cc0msh42e85ca9ad77f06p17e194jsn9119edc970ff';
  static const String _apiHost = 'free-api-live-football-data.p.rapidapi.com';

  Future<MatchStatsResponse> getMatchStats(String eventId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/football-get-match-all-stats?eventid=$eventId'),
        headers: {
          'x-rapidapi-key': _apiKey,
          'x-rapidapi-host': _apiHost,
        },
      );

      print("INI RESPONSE STATISTIK : $response");
      if (response.statusCode == 200) {
        return MatchStatsResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load match stats');
      }
    } catch (e) {
      throw Exception('Error fetching match stats: $e');
    }
  }
}
