// lib/app/core/injection/initial_binding.dart
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:livescore_plus/app/data/providers/api_provider.dart';
import 'package:livescore_plus/app/data/repositories/match_score_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/network_info.dart';
import '../../data/datasources/match_local_datasource.dart';
import '../../data/repositories/match_repository.dart';
import '../../data/repositories/match_repository_impl.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core
    final sharedPreferences = Get.find<SharedPreferences>();
    Get.put(InternetConnection());
    Get.put(Dio());

    // Network
    Get.put<NetworkInfo>(NetworkInfoImpl(Get.find()));

    // Data sources
    Get.put<MatchLocalDataSource>(
      MatchLocalDataSourceImpl(sharedPreferences: sharedPreferences),
    );
    Get.put<MatchRemoteDataSource>(
      MatchRemoteDataSourceImpl(dio: Get.find()),
    );

    Get.lazyPut(() => MatchScoreRepository(apiProvider: ApiProvider()));

    // Repository
    Get.put<LiveMatchRepository>(
      LiveMatchRepositoryImpl(
        remoteDataSource: Get.find(),
        localDataSource: Get.find(),
        networkInfo: Get.find(),
      ),
      permanent: true,
    );
  }
}
