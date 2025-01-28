import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:livescore_plus/app/data/models/detail_liga/detail_liga_model.dart';
import 'package:livescore_plus/app/data/providers/api_provider.dart';

class LeagueDetailRepository {
  final ApiProvider apiProvider;

  LeagueDetailRepository({required this.apiProvider});
  static const String _baseUrl =
      'https://free-api-live-football-data.p.rapidapi.com';
  static const String _apiKey =
      'cc36001cc0msh42e85ca9ad77f06p17e194jsn9119edc970ff';

  Future<LeagueDetail?> getLeagueDetail(int leagueId) async {
    final url =
        Uri.parse('$_baseUrl/football-get-league-detail?leagueid=$leagueId');

    try {
      final response = await http.get(
        url,
        headers: {
          'x-rapidapi-host': 'free-api-live-football-data.p.rapidapi.com',
          'x-rapidapi-key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final leagueDetail = LeagueDetailModel.fromJson(jsonResponse);
        return leagueDetail.response.leagues;
      } else {
        print(
            'Failed to load league details. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching league details: $e');
      return null;
    }
  }
}
