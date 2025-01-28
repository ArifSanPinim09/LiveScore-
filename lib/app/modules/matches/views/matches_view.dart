import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:livescore_plus/app/data/models/matches/matches_model.dart';
import 'package:livescore_plus/app/routes/app_pages.dart';
import '../controllers/matches_controller.dart';

class MatchesView extends GetView<MatchesController> {
  const MatchesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildFilterTabs(),
          _buildDateFilter(),
          Expanded(
            child: _buildMatchList(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.sports_soccer, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Text(
            'LiveScore+',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchCard(Matches match) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.MATCH_DETAIL, arguments: match.id),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: _buildCardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLeagueHeader(match),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildMatchTimeInfo(match),
                  const SizedBox(height: 16),
                  _buildTeamSection(match),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF2A2A3E), Color(0xFF1E1E32)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildTeamSection(Matches match) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Tim Pertama (Home) - Kiri Atas
          Row(
            children: [
              _buildTeamLogo(match.homeImageUrl),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  match.home.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (match.home.redCards != null && match.home.redCards! > 0)
                _buildRedCardIndicator(match.home.redCards!),
            ],
          ),

          // Bagian Tengah (Skor atau VS)
          SizedBox(height: 16),
          if (!match.status.finished && !match.status.started)
            Text(
              'VS',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )
          else
            _buildScoreSection(match),
          SizedBox(height: 16),

          // Tim Kedua (Away) - Kanan Bawah
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (match.away.redCards != null && match.away.redCards! > 0)
                _buildRedCardIndicator(match.away.redCards!),
              Expanded(
                child: Text(
                  match.away.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(width: 12),
              _buildTeamLogo(match.awayImageUrl),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeagueHeader(Matches match) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildLeagueLogo(match),
              SizedBox(width: 8),
              Text(
                match.shortName ?? 'Unknown League',
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeagueLogo(Matches match) {
    if (match.leagueLogo != null && match.leagueLogo!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: match.leagueLogo!,
        width: 24,
        height: 24,
        placeholder: (context, url) => _buildPlaceholderLogo(),
        errorWidget: (context, url, error) => _buildPlaceholderLogo(),
      );
    }
    return _buildPlaceholderLogo();
  }

  Widget _buildPlaceholderLogo() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(Icons.sports_soccer, size: 16, color: Colors.white60),
    );
  }

  Widget _buildMatchTimeInfo(Matches match) {
    final matchStatus = _getMatchStatus(match);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: matchStatus.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            matchStatus.icon,
            size: 16,
            color: matchStatus.color,
          ),
          SizedBox(width: 6),
          Text(
            matchStatus.text,
            style: TextStyle(
              color: matchStatus.color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamLogo(String? imageUrl) {
    return SizedBox(
      width: 36,
      height: 36,
      child: imageUrl != null && imageUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: (context, url) => Container(
                color: Colors.grey[900],
                child: Icon(Icons.sports_soccer,
                    size: 20, color: Colors.grey[600]),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[900],
                child: Icon(Icons.sports_soccer,
                    size: 20, color: Colors.grey[600]),
              ),
              fit: BoxFit.cover,
            )
          : Icon(Icons.sports_soccer, size: 20, color: Colors.grey[600]),
    );
  }

  Widget _buildRedCardIndicator(int count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.square, color: Colors.red, size: 12),
          SizedBox(width: 4),
          Text(
            count.toString(),
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreSection(Matches match) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          match.status.scoreStr,
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
          SizedBox(height: 16),
          Text(
            controller.errorMessage.value.toString(),
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => controller.refreshData(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4A90E2),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Obx(() => ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildFilterChip('Semua', 'all'),
              _buildFilterChip('Live', 'live'),
              _buildFilterChip('Akan Datang', 'upcoming'),
              _buildFilterChip('Selesai', 'completed'),
            ],
          )),
    );
  }

  Widget _buildFilterChip(String label, String filter) {
    final isSelected = controller.selectedFilter.value == filter;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        backgroundColor: const Color(0xFF2A2A3E),
        selectedColor: const Color(0xFF4A90E2),
        onSelected: (selected) {
          controller.selectedFilter.value = filter;
          controller.filterMatches();
        },
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildDateFilter() {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 7, // Show 7 days
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index - 3));
          return _buildDateChip(date);
        },
      ),
    );
  }

  Widget _buildDateChip(DateTime date) {
    final isSelected = DateFormat('yyyyMMdd').format(date) ==
        DateFormat('yyyyMMdd').format(controller.selectedDate.value);
    final isToday = DateFormat('yyyyMMdd').format(date) ==
        DateFormat('yyyyMMdd').format(DateTime.now());

    return GestureDetector(
      onTap: () {
        controller.selectedDate.value = date;
        controller.refreshData();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4A90E2) : const Color(0xFF2A2A3E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.white24 : Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isToday ? 'Hari Ini' : DateFormat('E').format(date),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Text(
              DateFormat('d MMM').format(date),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
          ),
        );
      } else if (controller.errorMessage.isNotEmpty) {
        return _buildErrorWidget();
      }

      return RefreshIndicator(
        onRefresh: () => controller.refreshData(),
        color: const Color(0xFF4A90E2),
        backgroundColor: const Color(0xFF2A2A3E),
        child: controller.filteredMatches.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                itemCount: controller.filteredMatches.length,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemBuilder: (context, index) {
                  final match = controller.filteredMatches[index] as Matches;
                  return _buildMatchCard(match);
                },
              ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.sports_soccer,
            size: 64,
            color: Colors.white24,
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada pertandingan',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class MatchStatus {
  final String text;
  final Color color;
  final IconData icon;

  MatchStatus({
    required this.text,
    required this.color,
    required this.icon,
  });
}

MatchStatus _getMatchStatus(Matches match) {
  if (match.status.finished) {
    return MatchStatus(
      text: 'Selesai',
      color: Colors.grey,
      icon: Icons.check_circle_outline,
    );
  }

  if (match.status.started) {
    return MatchStatus(
      text: 'LIVE',
      color: Colors.green,
      icon: Icons.fiber_manual_record,
    );
  }

  final matchTime = DateTime.parse(match.status.utcTime).toLocal();
  final now = DateTime.now();
  final difference = matchTime.difference(now);

  if (difference.inHours < 1) {
    return MatchStatus(
      text: '${difference.inMinutes} menit lagi',
      color: Colors.orange,
      icon: Icons.timer,
    );
  }

  if (difference.inHours < 24) {
    return MatchStatus(
      text: '${difference.inHours} jam lagi',
      color: Colors.blue,
      icon: Icons.access_time,
    );
  }

  return MatchStatus(
    text: DateFormat('E, dd MMM HH:mm').format(matchTime),
    color: Colors.blue,
    icon: Icons.calendar_today,
  );
}
