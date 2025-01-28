import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/standing_controller.dart';

class StandingView extends GetView<StandingController> {
  const StandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFF2A2A3E),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }
                  if (controller.errorMessage.value.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.errorMessage.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: controller.fetchStandings,
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
                  return _buildStandingsTable();
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF2A2A3E)],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'League Standings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStandingsTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTableHeader(),
              const SizedBox(height: 8),
              ...controller.standings.map((team) => _buildTeamRow(team)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 30), // Position number width
          const SizedBox(
              width: 200,
              child: Text('Team', style: TextStyle(color: Colors.white70))),
          const SizedBox(
              width: 40,
              child: Text('PL', style: TextStyle(color: Colors.white70))),
          const SizedBox(
              width: 40,
              child: Text('W', style: TextStyle(color: Colors.white70))),
          const SizedBox(
              width: 40,
              child: Text('D', style: TextStyle(color: Colors.white70))),
          const SizedBox(
              width: 40,
              child: Text('L', style: TextStyle(color: Colors.white70))),
          const SizedBox(
              width: 80,
              child: Text('GF:GA', style: TextStyle(color: Colors.white70))),
          const SizedBox(
              width: 40,
              child: Text('GD', style: TextStyle(color: Colors.white70))),
          const SizedBox(
              width: 40,
              child: Text('PTS',
                  style: TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildTeamRow(team) {
    Color statusColor = Colors.transparent;
    if (team.qualColor != null) {
      try {
        statusColor = Color(int.parse(team.qualColor.replaceAll('#', '0xFF')));
      } catch (e) {
        statusColor = Colors.transparent;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              '${team.idx}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            width: 200,
            child: Text(
              team.name,
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
              width: 40,
              child: Text('${team.played}',
                  style: const TextStyle(color: Colors.white))),
          SizedBox(
              width: 40,
              child: Text('${team.wins}',
                  style: const TextStyle(color: Colors.white))),
          SizedBox(
              width: 40,
              child: Text('${team.draws}',
                  style: const TextStyle(color: Colors.white))),
          SizedBox(
              width: 40,
              child: Text('${team.losses}',
                  style: const TextStyle(color: Colors.white))),
          SizedBox(
              width: 80,
              child: Text(team.scoresStr,
                  style: const TextStyle(color: Colors.white))),
          SizedBox(
            width: 40,
            child: Text(
              '${team.goalConDiff}',
              style: TextStyle(
                color: team.goalConDiff > 0
                    ? Colors.green
                    : team.goalConDiff < 0
                        ? Colors.red
                        : Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '${team.pts}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
