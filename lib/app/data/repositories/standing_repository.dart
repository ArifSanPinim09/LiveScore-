import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/standing_by_league.dart';

class StandingRepository {
  final String baseUrl = 'https://free-api-live-football-data.p.rapidapi.com';
  final Map<String, String> headers = {
    'x-rapidapi-host': 'free-api-live-football-data.p.rapidapi.com',
    'x-rapidapi-key': 'cc36001cc0msh42e85ca9ad77f06p17e194jsn9119edc970ff',
  };

  Future<StandingResponse> getStanding(int leagueId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/football-get-standing-all?leagueid=$leagueId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return StandingResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load standings: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching standings: $e');
    }
  }
}
