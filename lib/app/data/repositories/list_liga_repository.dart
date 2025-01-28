import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/list_league.dart';

class ListLigaRepository {
  final String baseUrl = 'https://free-api-live-football-data.p.rapidapi.com';
  final Map<String, String> headers = {
    'x-rapidapi-host': 'free-api-live-football-data.p.rapidapi.com',
    'x-rapidapi-key': 'cc36001cc0msh42e85ca9ad77f06p17e194jsn9119edc970ff',
  };

  Future<List<League>> getListLiga() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/football-get-all-leagues'),
        headers: headers,
      );

      print("Ini response list liga $response");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success' && data['response'] != null) {
          final allLeagues = (data['response']['leagues'] as List)
              .map((league) => League.fromJson(league))
              .toList();

          // Membatasi hanya mengambil 3 data liga
          final limitedLeagues = allLeagues.take(3).toList();
          return limitedLeagues;
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load leagues: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching leagues: $e');
    }
  }
}
