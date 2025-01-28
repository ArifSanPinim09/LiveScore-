import 'package:get/get.dart';

// lib/app/data/providers/api_provider.dart
class ApiProvider extends GetConnect {
  Future<Response> getMatchDetail(String eventId) async {
    try {
      final response = await get(
          'https://free-api-live-football-data.p.rapidapi.com/football-get-match-score',
          query: {
            'eventid': eventId
          },
          headers: {
            'x-rapidapi-host': 'free-api-live-football-data.p.rapidapi.com',
            'x-rapidapi-key':
                'cc36001cc0msh42e85ca9ad77f06p17e194jsn9119edc970ff'
          });

      return response;
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }
}
