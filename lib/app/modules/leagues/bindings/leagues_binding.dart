import 'package:get/get.dart';
import 'package:livescore_plus/app/data/repositories/list_liga_repository.dart';

import '../controllers/leagues_controller.dart';

class LeaguesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => LeaguesController(
        Get.find<ListLigaRepository>(),
      ),
    );
  }
}
