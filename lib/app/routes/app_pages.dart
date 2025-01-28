import 'package:get/get.dart';

import '../data/models/live_models/live_match_model.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/leagues/bindings/leagues_binding.dart';
import '../modules/leagues/views/leagues_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/match_detail/bindings/match_detail_binding.dart';
import '../modules/match_detail/views/match_detail_view.dart';
import '../modules/matches/bindings/matches_binding.dart';
import '../modules/matches/views/matches_view.dart';
import '../modules/standing/bindings/standing_binding.dart';
import '../modules/standing/views/standing_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.MAIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.MATCH_DETAIL,
      page: () => MatchDetailView(),
      binding: MatchDetailBinding(),
    ),
    GetPage(
      name: _Paths.MATCHES,
      page: () => const MatchesView(),
      binding: MatchesBinding(),
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: _Paths.LEAGUES,
      page: () => const LeaguesView(),
      binding: LeaguesBinding(),
    ),
    GetPage(
      name: _Paths.STANDING,
      page: () => const StandingView(),
      binding: StandingBinding(),
    ),
  ];
}
