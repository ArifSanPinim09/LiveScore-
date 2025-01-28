import 'package:get/get.dart';
import 'package:livescore_plus/app/data/providers/api_provider.dart';
import 'package:livescore_plus/app/data/repositories/league_detail_repository.dart';
import 'package:livescore_plus/app/data/repositories/lineup_repository.dart';
import 'package:livescore_plus/app/data/repositories/match_score_repository.dart';
import 'package:livescore_plus/app/data/repositories/match_stats_repository.dart';

import '../controllers/match_detail_controller.dart';

class MatchDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiProvider());
    Get.lazyPut(() => MatchScoreRepository(apiProvider: Get.find()));
    Get.lazyPut(
      () => MatchDetailController(
        repository: Get.find(),
        statsRepository: Get.find(),
        leagueDetailRepository: Get.find(),
        lineupRepository: Get.find(),
      ),
    );
    Get.lazyPut(() => LineupRepository());
    Get.lazyPut(() => LeagueDetailRepository(apiProvider: Get.find()));
    Get.lazyPut(() => MatchStatsRepository());
  }
}
