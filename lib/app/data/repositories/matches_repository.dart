import 'package:get/get.dart';
import 'package:livescore_plus/app/data/models/matches/matches_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MatchesRepository extends GetConnect {
  @override
  final String baseUrl = 'https://free-api-live-football-data.p.rapidapi.com';
  final Map<String, String> headers = {
    'x-rapidapi-host': 'free-api-live-football-data.p.rapidapi.com',
    'x-rapidapi-key': 'cc36001cc0msh42e85ca9ad77f06p17e194jsn9119edc970ff',
  };

  Future<List<Matches>> getMatchesByDate(String date) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/football-get-matches-by-date?date=$date'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final matches = (data['response']['matches'] as List)
            .map((match) => Matches.fromJson(match))
            .toList();

        // Batasi data menjadi 5 item
        return matches.length > 5 ? matches.sublist(0, 5) : matches;
      } else {
        throw Exception('Failed to load matches');
      }
    } catch (e) {
      throw Exception('Error fetching matches: $e');
    }
  }

  Future<List<Matches>> getMatchesByDateAndLeague(String date) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/football-get-matches-by-date-and-league?date=$date'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Matches> allMatches = [];

        for (var league in data['response']) {
          final leagueName = league['name'];
          final matches = (league['matches'] as List).map((match) {
            match['leagueName'] = leagueName;
            return Matches.fromJson(match);
          }).toList();
          allMatches.addAll(matches);
        }

        // Batasi data menjadi 5 item
        return allMatches.length > 5 ? allMatches.sublist(0, 5) : allMatches;
      } else {
        throw Exception('Failed to load league matches');
      }
    } catch (e) {
      throw Exception('Error fetching league matches: $e');
    }
  }

  Future<List<Matches>> getMatchesByLeagueId(String leagueId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/football-get-all-matches-by-league?leagueid=$leagueId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final matches = (data['response']['matches'] as List)
            .map((match) => Matches.fromJson(match))
            .toList();

        // Batasi data menjadi 5 item
        return matches.length > 5 ? matches.sublist(0, 5) : matches;
      } else {
        throw Exception('Failed to load league matches');
      }
    } catch (e) {
      throw Exception('Error fetching league matches: $e');
    }
  }
}
