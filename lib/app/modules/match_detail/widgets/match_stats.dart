// match_stats_view.dart
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:get/get.dart';
import 'package:livescore_plus/app/data/models/match_stats/match_stats_model.dart';
import '../controllers/match_detail_controller.dart';

class MatchStatsView extends StatelessWidget {
  final MatchDetailController controller;

  // Definisi warna untuk tim
  final Color homeTeamColor = const Color(0xFFE53935); // Merah
  final Color awayTeamColor = const Color(0xFF1E88E5); // Biru

  const MatchStatsView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final padding = screenWidth * 0.04;

    if (controller.isLoading.value) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFE53935), // Menggunakan warna merah untuk loading
        ),
      );
    }

    if (controller.errorMessage.value.isNotEmpty) {
      return Center(
        child: Text(
          controller.errorMessage.value,
          style: const TextStyle(color: Colors.white70),
        ),
      );
    }

    final stats = controller.matchStats.value?.response.stats.first.stats;
    if (stats == null) {
      return const Center(
        child: Text(
          'No stats available',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPossessionBar(context, stats[0]),
          const SizedBox(height: 24),
          _buildStatsSection(context, stats, isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildStatsSection(
      BuildContext context, List stats, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Expected Goals (xG)', isSmallScreen),
        const SizedBox(height: 12),
        _buildStatItem(
          FontAwesome.bullseye_solid,
          'xG',
          stats[1].stats[0].toString(),
          stats[1].stats[1].toString(),
          isSmallScreen,
          isDecimal: true,
          highlighted: stats[1].highlighted,
        ),
        _buildDivider(),
        _buildSectionTitle('Shooting', isSmallScreen),
        const SizedBox(height: 12),
        _buildShootingStats(stats, isSmallScreen),
        _buildDivider(),
        _buildSectionTitle('Build Up', isSmallScreen),
        const SizedBox(height: 12),
        _buildBuildUpStats(context, stats, isSmallScreen),
      ],
    );
  }

  Widget _buildShootingStats(List stats, bool isSmallScreen) {
    return Column(
      children: [
        _buildStatItem(
          FontAwesome.futbol,
          'Total Shots',
          stats[2].stats[0].toString(),
          stats[2].stats[1].toString(),
          isSmallScreen,
          highlighted: stats[2].highlighted,
        ),
        _buildStatItem(
          FontAwesome.bullseye_solid,
          'Shots on Target',
          stats[3].stats[0].toString(),
          stats[3].stats[1].toString(),
          isSmallScreen,
          highlighted: stats[3].highlighted,
        ),
        _buildStatItem(
          FontAwesome.star,
          'Big Chances',
          stats[4].stats[0].toString(),
          stats[4].stats[1].toString(),
          isSmallScreen,
          highlighted: stats[4].highlighted,
        ),
        _buildStatItem(
          FontAwesome.xmark_solid,
          'Big Chances Missed',
          stats[5].stats[0].toString(),
          stats[5].stats[1].toString(),
          isSmallScreen,
          highlighted: stats[5].highlighted,
        ),
      ],
    );
  }

  Widget _buildBuildUpStats(
      BuildContext context, List stats, bool isSmallScreen) {
    return Column(
      children: [
        _buildDetailedStats(context, stats[6]),
        const SizedBox(height: 16),
        _buildStatItem(
          FontAwesome.flag,
          'Corners',
          stats[8].stats[0].toString(),
          stats[8].stats[1].toString(),
          isSmallScreen,
          highlighted: stats[8].highlighted,
        ),
      ],
    );
  }

  Widget _buildPossessionBar(BuildContext context, StatItem possession) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    final textSize = isSmallScreen ? 12.0 : 14.0;
    final homePos = int.parse(possession.stats[0].toString());
    final awayPos = int.parse(possession.stats[1].toString());

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$homePos%',
              style: TextStyle(
                fontSize: textSize,
                fontWeight: FontWeight.bold,
                color: homeTeamColor,
              ),
            ),
            Row(
              children: [
                Icon(
                  FontAwesome.futbol,
                  color: Colors.white60,
                  size: textSize,
                ),
                const SizedBox(width: 4),
                Text(
                  'Ball Possession',
                  style: TextStyle(
                    fontSize: textSize,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Text(
              '$awayPos%',
              style: TextStyle(
                fontSize: textSize,
                fontWeight: FontWeight.bold,
                color: awayTeamColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white.withOpacity(0.1),
          ),
          child: Row(
            children: [
              Expanded(
                flex: homePos,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(4),
                      bottomLeft: const Radius.circular(4),
                      topRight: Radius.circular(homePos == 100 ? 4 : 0),
                      bottomRight: Radius.circular(homePos == 100 ? 4 : 0),
                    ),
                    color: homeTeamColor,
                  ),
                ),
              ),
              Expanded(
                flex: awayPos,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: const Radius.circular(4),
                      bottomRight: const Radius.circular(4),
                      topLeft: Radius.circular(awayPos == 100 ? 4 : 0),
                      bottomLeft: Radius.circular(awayPos == 100 ? 4 : 0),
                    ),
                    color: awayTeamColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Home Team',
              style: TextStyle(
                fontSize: textSize - 2,
                color: homeTeamColor.withOpacity(0.7),
              ),
            ),
            Text(
              'Away Team',
              style: TextStyle(
                fontSize: textSize - 2,
                color: awayTeamColor.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailedStats(BuildContext context, StatItem passes) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    final homePassesData = passes.stats[0]
        .toString()
        .replaceAll('%', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .split(' ');
    final awayPassesData = passes.stats[1]
        .toString()
        .replaceAll('%', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .split(' ');

    return Column(
      children: [
        _buildStatItem(
          FontAwesome.arrows_left_right_solid,
          'Total Passes',
          homePassesData[0],
          awayPassesData[0],
          isSmallScreen,
          highlighted: passes.highlighted,
        ),
        _buildStatItem(
          FontAwesome.check_double_solid,
          'Pass Accuracy',
          '${homePassesData[1]}%',
          '${awayPassesData[1]}%',
          isSmallScreen,
          highlighted: passes.highlighted,
        ),
      ],
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String label,
    String home,
    String away,
    bool isSmallScreen, {
    bool isDecimal = false,
    String highlighted = 'equal',
  }) {
    Color getHighlightColor(String side) {
      if (highlighted == 'equal') return Colors.white;
      if (side == 'home') return homeTeamColor;
      if (side == 'away') return awayTeamColor;
      return Colors.white70;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              isDecimal ? home : home,
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.bold,
                color: getHighlightColor('home'),
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: isSmallScreen ? 16 : 18,
                  color: Colors.white60,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      color: Colors.white60,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              isDecimal ? away : away,
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.bold,
                color: getHighlightColor('away'),
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isSmallScreen) {
    return Text(
      title,
      style: TextStyle(
        fontSize: isSmallScreen ? 14 : 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        height: 1,
        color: Colors.white.withOpacity(0.1),
      ),
    );
  }
}
