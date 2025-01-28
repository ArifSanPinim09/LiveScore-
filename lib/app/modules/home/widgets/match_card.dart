import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:livescore_plus/app/data/models/live_models/live_match_model.dart';
import 'package:livescore_plus/app/routes/app_pages.dart';

class MatchCard extends StatelessWidget {
  final LiveMatchModel match;

  const MatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.MATCH_DETAIL, arguments: match.id),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: _buildCardDecoration(),
        child: Column(
          children: [
            _buildMatchHeader(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildTeamsAndScore(),
                  if (_hasRedCards()) _buildRedCards(),
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
      gradient: const LinearGradient(
        colors: [Color(0xFF2A2A3E), Color(0xFF1E1E32)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildMatchHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          _buildLeagueLogo(),
          _buildLeagueName(),
          const Spacer(),
          _buildMatchStatus(),
        ],
      ),
    );
  }

  Widget _buildLeagueLogo() {
    if (match.leagueLogo != null) {
      return CachedNetworkImage(
        imageUrl: match.leagueLogo!,
        width: 24,
        height: 24,
        placeholder: (context, url) => Container(
          width: 24,
          height: 24,
          color: Colors.grey[800],
          child: const Center(
            child: Icon(Icons.sports_soccer, size: 16, color: Colors.white60),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: 24,
          height: 24,
          color: Colors.grey[800],
          child: const Center(
            child: Icon(Icons.sports_soccer, size: 16, color: Colors.white60),
          ),
        ),
      );
    }
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Icon(Icons.sports_soccer, size: 16, color: Colors.white60),
    );
  }

  Widget _buildLeagueName() {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        match.shortName ?? 'Unknown League',
        style: TextStyle(
          color: Colors.grey[400],
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildMatchStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        match.status.liveTime.short,
        style: TextStyle(
          color: _getStatusColor(),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getStatusColor() {
    if (match.status.finished == true) return Colors.grey;
    if (match.status.started == true) return const Color(0xFF4CAF50);
    return const Color(0xFF4A90E2);
  }

  Widget _buildTeamsAndScore() {
    return Column(
      children: [
        _buildTeamRow(match.home, match.homeImageUrl, true),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            match.status.scoreStr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildTeamRow(match.away, match.awayImageUrl, false),
      ],
    );
  }

  Widget _buildTeamRow(dynamic team, String? imageUrl, bool isHome) {
    return Row(
      children: [
        if (!isHome) const Spacer(),
        if (imageUrl != null)
          CachedNetworkImage(
            imageUrl: imageUrl,
            width: 32,
            height: 32,
            imageBuilder: (context, imageProvider) => Container(
              margin: EdgeInsets.only(
                  right: isHome ? 12 : 0, left: isHome ? 0 : 12),
              decoration: BoxDecoration(
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24, width: 1),
              ),
            ),
            placeholder: (context, url) => Container(
              width: 32,
              height: 32,
              margin: EdgeInsets.only(
                  right: isHome ? 12 : 0, left: isHome ? 0 : 12),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              width: 32,
              height: 32,
              margin: EdgeInsets.only(
                  right: isHome ? 12 : 0, left: isHome ? 0 : 12),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        Text(
          team.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: isHome ? TextAlign.left : TextAlign.right,
        ),
        if (isHome) const Spacer(),
      ],
    );
  }

  bool _hasRedCards() {
    return (match.home.redCards != null && match.home.redCards! > 0) ||
        (match.away.redCards != null && match.away.redCards! > 0);
  }

  Widget _buildRedCards() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (match.home.redCards != null && match.home.redCards! > 0)
            _buildRedCardIndicator(match.home.redCards!),
          if (match.away.redCards != null && match.away.redCards! > 0)
            _buildRedCardIndicator(match.away.redCards!),
        ],
      ),
    );
  }

  Widget _buildRedCardIndicator(int count) {
    return Row(
      children: List.generate(
        count,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Container(
            width: 12,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.red[700],
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
