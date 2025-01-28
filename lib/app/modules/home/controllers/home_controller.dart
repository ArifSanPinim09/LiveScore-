import 'package:get/get.dart';
import 'package:livescore_plus/app/data/models/live_models/live_match_model.dart';
import 'package:livescore_plus/app/data/repositories/league_detail_repository.dart';
import 'package:livescore_plus/app/data/repositories/league_logo_repository.dart';
import 'package:livescore_plus/app/data/repositories/match_repository.dart';
import 'package:livescore_plus/app/data/repositories/match_score_repository.dart';
import 'package:livescore_plus/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final LiveMatchRepository _repository;
  final MatchScoreRepository _detailRepository;
  final LeagueDetailRepository _leagueDetailRepository;
  final LeagueLogoRepository _leagueLogoRepository;
  final matches = <LiveMatchModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Konstanta untuk membatasi jumlah pertandingan
  static const int maxMatches = 2;

  final leagueShortNames = <int, String>{}.obs;
  final leagueLogos = <int, String>{}.obs;

  HomeController(
    this._repository,
    this._detailRepository,
    this._leagueDetailRepository,
    this._leagueLogoRepository,
  );

  @override
  void onInit() {
    super.onInit();
    fetchLiveMatches();
  }

  Future<void> fetchLiveMatches() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await _repository.getLiveMatches();

      result.fold(
        (failure) => errorMessage.value = failure.message,
        (liveMatches) async {
          // Ambil hanya 2 pertandingan pertama
          final limitedMatches = liveMatches.take(maxMatches).toList();

          final updatedMatches = await Future.wait(
            limitedMatches.map((match) async {
              try {
                print(
                    'Processing match ${match.id} for league ${match.leagueId}');

                // Fetch league short name
                final shortName = await _fetchLeagueShortName(match.leagueId);
                if (shortName != null) {
                  match.shortName = shortName;
                }

                // Fetch match details (including team images)
                final detail =
                    await _detailRepository.getMatchDetail(match.id.toString());
                if (detail.response.scores.isNotEmpty) {
                  (match as LiveMatchModel).homeImageUrl =
                      detail.response.scores[0].imageUrl;
                  match.awayImageUrl = detail.response.scores[1].imageUrl;
                }

                return match;
              } catch (e) {
                print('Error processing match ${match.id}: $e');
                return match; // Return original match if processing fails
              }
            }),
          );

          matches.value = updatedMatches.cast<LiveMatchModel>();
        },
      );
    } catch (e) {
      errorMessage.value = 'Failed to fetch live matches: $e';
      print('Detailed error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> _fetchLeagueShortName(int leagueId) async {
    try {
      // Check if we already have the short name cached
      if (leagueShortNames.containsKey(leagueId)) {
        return leagueShortNames[leagueId];
      }

      final leagueDetail =
          await _leagueDetailRepository.getLeagueDetail(leagueId);

      if (leagueDetail != null) {
        leagueShortNames[leagueId] = leagueDetail.shortName;
        return leagueDetail.shortName;
      }
    } catch (e) {
      print('Error fetching league short name for league $leagueId: $e');
    }
    return null;
  }

  String getLeagueShortName(int leagueId) {
    return leagueShortNames[leagueId] ?? 'Unknown';
  }

  void navigateToMatchDetail(String matchId) {
    Get.toNamed(Routes.MATCH_DETAIL, arguments: matchId);
  }
}
