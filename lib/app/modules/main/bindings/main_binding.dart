import 'package:get/get.dart';
import 'package:livescore_plus/app/data/providers/api_provider.dart';
import 'package:livescore_plus/app/data/repositories/league_detail_repository.dart';
import 'package:livescore_plus/app/data/repositories/league_logo_repository.dart';
import 'package:livescore_plus/app/data/repositories/list_liga_repository.dart';
import 'package:livescore_plus/app/data/repositories/match_repository.dart';
import 'package:livescore_plus/app/data/repositories/match_score_repository.dart';
import 'package:livescore_plus/app/data/repositories/matches_repository.dart';
import 'package:livescore_plus/app/modules/home/controllers/home_controller.dart';
import 'package:livescore_plus/app/modules/leagues/controllers/leagues_controller.dart';
import 'package:livescore_plus/app/modules/matches/controllers/matches_controller.dart';

import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Gunakan Get.lazyPut untuk MainController
    Get.lazyPut<MainController>(
      () => MainController(),
    );

    // Gunakan Get.lazyPut untuk LeagueDetailRepository
    Get.lazyPut(
        () => LeagueDetailRepository(apiProvider: Get.put(ApiProvider())));

    Get.lazyPut(
        () => LeagueLogoRepository(apiProvider: Get.put(ApiProvider())));

    // Gunakan Get.lazyPut untuk HomeController
    Get.lazyPut(() => HomeController(
          Get.find<LiveMatchRepository>(),
          Get.find(),
          Get.find<LeagueDetailRepository>(),
          Get.find<LeagueLogoRepository>(),
        ));

    // Gunakan Get.lazyPut untuk MatchesController
    Get.lazyPut(() => MatchesController(
          Get.put(MatchesRepository()),
          Get.put(
            MatchScoreRepository(
              apiProvider: Get.put(ApiProvider()),
            ),
          ),
          Get.find<LeagueDetailRepository>(),
          Get.find<LeagueLogoRepository>(),
        ));

    Get.lazyPut(() => LeaguesController(Get.find<ListLigaRepository>()));
    Get.lazyPut(() => ListLigaRepository());
  }
}
