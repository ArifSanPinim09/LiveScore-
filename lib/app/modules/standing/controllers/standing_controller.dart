import 'package:get/get.dart';
import 'package:livescore_plus/app/data/models/standing_by_league.dart';
import 'package:livescore_plus/app/data/repositories/standing_repository.dart';

class StandingController extends GetxController {
  final StandingRepository _standingRepository;
  final int leagueId;

  StandingController(this._standingRepository, this.leagueId);

  final standings = <TeamStanding>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStandings();
  }

  Future<void> fetchStandings() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _standingRepository.getStanding(leagueId);

      if (response.response?.standing != null) {
        standings.value = response.response!.standing;
      } else {
        standings.value = [];
        errorMessage.value = 'No standings data available';
      }
    } catch (e) {
      errorMessage.value = e.toString();
      standings.value = [];
    } finally {
      isLoading.value = false;
    }
  }
}
