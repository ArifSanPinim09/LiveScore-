import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:livescore_plus/app/data/models/league_model/league_logo_model.dart';
import 'package:livescore_plus/app/data/providers/api_provider.dart';

class LeagueLogoRepository {
  final ApiProvider apiProvider;

  LeagueLogoRepository({required this.apiProvider});
  static const String _baseUrl =
      'https://free-api-live-football-data.p.rapidapi.com';
  static const String _apiKey =
      'cc36001cc0msh42e85ca9ad77f06p17e194jsn9119edc970ff';

  Future<String?> getLeagueLogo(int leagueId) async {
    final url =
        Uri.parse('$_baseUrl/football-get-league-logo?leagueid=$leagueId');

    try {
      final response = await http.get(
        url,
        headers: {
          'x-rapidapi-host': 'free-api-live-football-data.p.rapidapi.com',
          'x-rapidapi-key': _apiKey,
        },
      );

      print("Ini Response Body : $response");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final leagueLogo = LeagueLogoModel.fromJson(jsonResponse);
        return leagueLogo.response.url;
      } else {
        print(
            'Failed to load league logo. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching league logo: $e');
      return null;
    }
  }

  // Metode untuk cache logo jika diperlukan
  Future<String?> getCachedLeagueLogo(int leagueId) async {
    // Implementasi cache sederhana (opsional)
    // Anda bisa menggunakan paket seperti shared_preferences atau sembast
    return await getLeagueLogo(leagueId);
  }
}
