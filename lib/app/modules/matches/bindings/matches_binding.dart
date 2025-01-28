import 'package:get/get.dart';
import 'package:livescore_plus/app/data/repositories/league_detail_repository.dart';
import 'package:livescore_plus/app/data/repositories/league_logo_repository.dart';
import 'package:livescore_plus/app/data/repositories/match_score_repository.dart';
import 'package:livescore_plus/app/data/repositories/matches_repository.dart';

import '../controllers/matches_controller.dart';

class MatchesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MatchesController>(
      () => MatchesController(
        Get.put(MatchesRepository()),
        Get.put(
          MatchScoreRepository(
            apiProvider: Get.find(),
          ),
        ),
        Get.find<LeagueDetailRepository>(),
        Get.find<LeagueLogoRepository>(),
      ),
    );
  }
}
