import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:livescore_plus/app/data/repositories/match_repository.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(
          Get.find<MatchRepository>(),
        ));

    Get.lazyPut(() => InternetConnection());
  }
}
