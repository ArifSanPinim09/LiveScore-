import 'package:get/get.dart';
import 'package:livescore_plus/app/data/models/matches/matches_model.dart';
import 'package:livescore_plus/app/data/repositories/league_detail_repository.dart';
import 'package:livescore_plus/app/data/repositories/league_logo_repository.dart';
import 'package:livescore_plus/app/data/repositories/match_score_repository.dart';
import 'package:livescore_plus/app/data/repositories/matches_repository.dart';
import 'package:livescore_plus/app/routes/app_pages.dart';

class MatchesController extends GetxController {
  final MatchesRepository repository;
  final MatchScoreRepository _matchScoreRepository;
  final LeagueDetailRepository _leagueDetailRepository;
  final LeagueLogoRepository _leagueLogoRepository;

  MatchesController(
    this.repository,
    this._matchScoreRepository,
    this._leagueDetailRepository,
    this._leagueLogoRepository,
  );

  // Data states
  final matches = <dynamic>[].obs;
  final filteredMatches = <dynamic>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Filter states
  final selectedDate = DateTime.now().obs;
  final selectedFilter = 'all'.obs;
  final leagueShortNames = <int, String>{}.obs;
  final leagueLogos = <int, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    String date = _formatDate(selectedDate.value);
    await fetchMatchesByDate(date);
  }

  Future<void> refreshData({String? date}) async {
    String targetDate = date ?? _formatDate(selectedDate.value);
    await fetchMatchesByDate(targetDate);
  }

  void filterMatches() {
    switch (selectedFilter.value) {
      case 'live':
        filteredMatches.value = matches
            .where((match) =>
                (match as Matches).status.started && !match.status.finished)
            .toList();
        break;
      case 'upcoming':
        filteredMatches.value = matches
            .where((match) =>
                !(match as Matches).status.started && !match.status.finished)
            .toList();
        break;
      case 'completed':
        filteredMatches.value = matches
            .where((match) => (match as Matches).status.finished)
            .toList();
        break;
      case 'all':
      default:
        filteredMatches.value = matches.toList();
        break;
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> fetchMatchesByDate(String date) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final matchesData = await repository.getMatchesByDate(date);

      final updatedMatches = await Future.wait(
        matchesData.map((match) async {
          try {
            final shortName =
                await _fetchLeagueShortName(int.parse(match.leagueId));
            final logoUrl = await _fetchLeagueLogo(int.parse(match.leagueId));

            if (shortName != null) {
              match.shortName = shortName;
            }
            if (logoUrl != null) {
              match.leagueLogo = logoUrl;
            }

            final detail = await _matchScoreRepository.getMatchDetail(match.id);
            if (detail.response.scores.isNotEmpty) {
              match.homeImageUrl = detail.response.scores[0].imageUrl;
              match.awayImageUrl = detail.response.scores[1].imageUrl;
            }
          } catch (e) {
            print('Error processing match ${match.id}: $e');
          }
          return match;
        }),
      );

      matches.value = updatedMatches;
      filterMatches(); // Apply current filter to new data
    } catch (e) {
      errorMessage.value = 'Failed to fetch matches: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> _fetchLeagueShortName(int leagueId) async {
    try {
      if (leagueShortNames.containsKey(leagueId)) {
        return leagueShortNames[leagueId];
      }

      final leagueDetail =
          await _leagueDetailRepository.getLeagueDetail(leagueId);
      if (leagueDetail != null) {
        final shortName = leagueDetail.shortName;
        leagueShortNames[leagueId] = shortName;
        return shortName;
      }
    } catch (e) {
      print('Error fetching league short name for league $leagueId: $e');
    }
    return null;
  }

  Future<String?> _fetchLeagueLogo(int leagueId) async {
    try {
      if (leagueLogos.containsKey(leagueId)) {
        return leagueLogos[leagueId];
      }

      final leagueLogo = await _leagueLogoRepository.getLeagueLogo(leagueId);
      if (leagueLogo != null) {
        leagueLogos[leagueId] = leagueLogo;
        return leagueLogo;
      }
    } catch (e) {
      print('Error fetching league logo for league $leagueId: $e');
    }
    return null;
  }

  // Metode untuk mendapatkan shortName
  String getLeagueShortName(int leagueId) {
    return leagueShortNames[leagueId] ?? 'Unknown';
  }

  void navigateToMatchDetail(String matchId, String leagueName) {
    Get.toNamed(Routes.MATCH_DETAIL, arguments: {
      'matchId': matchId,
      'leagueName': leagueName,
    });
  }
}
