import 'package:get/get.dart';
import 'package:livescore_plus/app/data/models/line_up/lineup_model.dart';
import 'package:livescore_plus/app/data/models/match_detail/match_detail_model.dart';
import 'package:livescore_plus/app/data/models/match_stats/match_stats_model.dart';
import 'package:livescore_plus/app/data/repositories/league_detail_repository.dart';
import 'package:livescore_plus/app/data/repositories/lineup_repository.dart';
import 'package:livescore_plus/app/data/repositories/match_score_repository.dart';
import 'package:livescore_plus/app/data/repositories/match_stats_repository.dart';

class MatchDetailController extends GetxController {
  final MatchStatsRepository statsRepository;
  final MatchScoreRepository repository;
  final LeagueDetailRepository leagueDetailRepository;
  final LineupRepository lineupRepository;

  final matchStats = Rxn<MatchStatsResponse>();
  final matchScores = Rxn<MatchScores>();
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final leagueShortNames = <int, String>{}.obs;
  final homeLineup = Rxn<TeamLineup>();
  final awayLineup = Rxn<TeamLineup>();
  final selectedTabIndex = 0.obs;

  MatchDetailController({
    required this.repository,
    required this.statsRepository,
    required this.leagueDetailRepository,
    required this.lineupRepository,
  });

  @override
  void onInit() {
    super.onInit();
    String? matchId = Get.arguments;
    if (matchId != null) {
      fetchMatchDetail(matchId);
      fetchMatchStats(matchId.toString());
      _fetchLeagueShortName(int.parse(matchId));
      fetchLineups(matchId.toString());
    }
  }

  Future<void> fetchMatchDetail(String id) async {
    try {
      isLoading.value = true;
      final result = await repository.getMatchDetail(id);
      matchScores.value = result.response;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMatchStats(String id) async {
    try {
      isLoading.value = true;
      final result = await statsRepository.getMatchStats(id);
      matchStats.value = result;
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> _fetchLeagueShortName(int leagueId) async {
    try {
      // Cek apakah shortName sudah ada di cache
      if (leagueShortNames.containsKey(leagueId)) {
        return leagueShortNames[leagueId];
      }

      final leagueDetail =
          await leagueDetailRepository.getLeagueDetail(leagueId);

      // Pastikan leagueDetail tidak null dan memiliki shortName
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

  Future<void> fetchLineups(String eventId) async {
    try {
      isLoading.value = true;
      // Fetch both lineups concurrently
      final results = await Future.wait([
        lineupRepository.getHomeLineup(eventId),
        lineupRepository.getAwayLineup(eventId),
      ]);

      homeLineup.value = results[0].response.lineup;
      awayLineup.value = results[1].response.lineup;
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Error fetching lineups: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
