import 'package:get/get.dart';
import 'package:livescore_plus/app/data/repositories/standing_repository.dart';

import '../controllers/standing_controller.dart';

class StandingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StandingRepository());
    Get.lazyPut(() => StandingController(
          Get.find<StandingRepository>(),
          Get.arguments['leagueId'] as int,
        ));
  }
}
