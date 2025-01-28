// # lib/app/data/repositories/match_repository.dart
import 'package:livescore_plus/app/data/models/match_detail/match_detail_model.dart';
import 'package:livescore_plus/app/data/providers/api_provider.dart';

class MatchScoreRepository {
  final ApiProvider apiProvider;

  MatchScoreRepository({required this.apiProvider});

  Future<MatchDetailResponse> getMatchDetail(String eventId) async {
    try {
      final response = await apiProvider.getMatchDetail(eventId);
      if (response.body == null) {
        throw Exception('Empty response');
      }
      return MatchDetailResponse.fromJson(response.body);
    } catch (e) {
      print('Repository Error: $e');
      throw Exception('Failed to fetch match detail');
    }
  }
}
