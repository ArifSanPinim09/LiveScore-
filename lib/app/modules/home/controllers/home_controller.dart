import 'package:get/get.dart';
import 'package:livescore_plus/app/data/models/live_match_model.dart';
import 'package:livescore_plus/app/data/repositories/match_repository.dart';

class HomeController extends GetxController {
  final MatchRepository _repository;
  final matches = <LiveMatch>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  HomeController(this._repository);

  @override
  void onInit() {
    super.onInit();
    fetchLiveMatches();
  }

  Future<void> fetchLiveMatches() async {
    try {
      isLoading.value = true;
      error.value = '';
      final result = await _repository.getLiveMatches();
      result.fold(
        (failure) => error.value = failure.message,
        (liveMatches) => matches.value = liveMatches,
      );
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
