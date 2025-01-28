import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:livescore_plus/app/data/models/live_models/live_match_model.dart';
import 'package:livescore_plus/app/data/models/match_detail/match_detail_model.dart';
import 'package:livescore_plus/app/modules/match_detail/widgets/match_lineup.dart';
import 'package:livescore_plus/app/modules/match_detail/widgets/match_stats.dart';
import '../controllers/match_detail_controller.dart';

class MatchDetailView extends GetView<MatchDetailController> {
  const MatchDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 360;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "Liga",
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
            Text(
              'Matchweek 24',
              style: TextStyle(
                color: Colors.white60,
                fontSize: isSmallScreen ? 10 : 12,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            FontAwesome.chevron_left_solid,
            color: Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              FontAwesome.star,
              color: Colors.white60,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              FontAwesome.share_solid,
              color: Colors.white60,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF4A90E2),
            ),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchMatchDetail(Get.arguments),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90E2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final scores = controller.matchScores.value;
        if (scores == null) {
          return const Text(
            'Data tidak ditemukan',
            style: TextStyle(color: Colors.white70),
          );
        }

        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF2A2A3E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildScoreBoard(context, scores),
                _buildTabBar(context),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildScoreBoard(BuildContext context, MatchScores scores) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final teamInfoWidth = screenWidth * 0.25;
    final scoreSize = isSmallScreen ? 28.0 : 32.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A1A2E), Color(0xFF2A2A3E)],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: teamInfoWidth,
                child: _buildTeamInfo(scores.scores[0]),
              ),
              Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A90E2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          FontAwesome.circle,
                          color: Colors.white,
                          size: 8,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'LIVE',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "67",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 20 : 24,
                    ),
                  ),
                  Text(
                    '${scores.scores[0].score} - ${scores.scores[1].score}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: scoreSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: teamInfoWidth,
                child: _buildTeamInfo(scores.scores[1]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    FontAwesome.futbol,
                    color: Colors.white60,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Rashford 23\', Fernandes 45\'',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    FontAwesome.futbol,
                    color: Colors.white60,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Salah 55\'',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamInfo(TeamScore team) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(team.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          team.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final itemWidth = screenWidth / 4;

    return Column(
      children: [
        Container(
          color: const Color(0xFF2A2A3E),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTabItem(
                FontAwesome.chart_bar,
                'Stats',
                0,
                itemWidth,
                isSmallScreen,
                controller.selectedTabIndex,
              ),
              _buildTabItem(
                FontAwesome.user,
                'Line-ups',
                1,
                itemWidth,
                isSmallScreen,
                controller.selectedTabIndex,
              ),
              _buildTabItem(
                FontAwesome.clock,
                'Timeline',
                2,
                itemWidth,
                isSmallScreen,
                controller.selectedTabIndex,
              ),
              _buildTabItem(
                FontAwesome.chart_line_solid,
                'H2H',
                3,
                itemWidth,
                isSmallScreen,
                controller.selectedTabIndex,
              ),
            ],
          ),
        ),
        // Tampilkan konten berdasarkan tab yang dipilih
        Obx(() {
          switch (controller.selectedTabIndex.value) {
            case 0:
              return _buildMatchStats(context); // Tampilkan stats
            case 1:
              return _buildLineups(); // Tampilkan line-ups
            case 2:
              return Container(); // Tampilkan timeline (jika ada)
            case 3:
              return Container(); // Tampilkan head-to-head (jika ada)
            default:
              return const SizedBox.shrink(); // Default kosong
          }
        }),
      ],
    );
  }

  Widget _buildLineups() {
    if (controller.isLoading.value) {
      return const Center(
          child: CircularProgressIndicator(
        color: Color(0xFF4A90E2),
      ));
    }

    final homeLineup = controller.homeLineup.value;
    final awayLineup = controller.awayLineup.value;

    if (homeLineup == null || awayLineup == null) {
      return const Center(
        child: Text(
          'Lineup not available',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return MatchLineupView(
      homeTeam: homeLineup,
      awayTeam: awayLineup,
    );
  }

  Widget _buildTabItem(
    IconData icon,
    String label,
    int tabIndex,
    double width,
    bool isSmallScreen,
    RxInt selectedTabIndex,
  ) {
    final isSelected = selectedTabIndex.value == tabIndex;

    return GestureDetector(
      onTap: () {
        selectedTabIndex.value = tabIndex; // Update tab yang dipilih
      },
      child: SizedBox(
        width: width,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFF4A90E2) : Colors.white60,
                size: isSmallScreen ? 20 : 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF4A90E2) : Colors.white60,
                  fontSize: isSmallScreen ? 10 : 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchStats(BuildContext context) {
    return MatchStatsView(controller: controller);
  }
}
