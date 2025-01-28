import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:livescore_plus/app/modules/home/views/home_view.dart';
import 'package:livescore_plus/app/modules/leagues/views/leagues_view.dart';
import 'package:livescore_plus/app/modules/matches/views/matches_view.dart';

import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: const [
              HomeView(),
              MatchesView(),
              LeaguesView(),
            ],
          )),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Obx(() => Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A3E),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changePage,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: const Color(0xFF4A90E2),
            unselectedItemColor: Colors.grey[600],
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.sports_soccer),
                label: 'Live',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: 'Matches',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.emoji_events),
                label: 'Leagues',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star_border),
                label: 'Favorites',
              ),
            ],
          ),
        ));
  }
}
