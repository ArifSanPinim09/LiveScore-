import 'package:get/get.dart';
import 'package:livescore_plus/app/data/models/list_league.dart';
import 'package:livescore_plus/app/data/repositories/list_liga_repository.dart';

class LeaguesController extends GetxController {
  final ListLigaRepository _listLigaRepository;

  LeaguesController(this._listLigaRepository);

  final leagues = <League>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchListLeagues();
  }

  Future<void> fetchListLeagues() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      final leaguesData = await _listLigaRepository.getListLiga();
      leagues.value = leaguesData;

      print(leaguesData);
    } catch (e) {
      errorMessage.value = 'Failed to load leagues: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
}
