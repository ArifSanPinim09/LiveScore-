import 'package:flutter/material.dart';
import 'package:livescore_plus/app/data/models/live_match_model.dart';

class MatchCard extends StatelessWidget {
  final LiveMatch match;

  const MatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMatchHeader(),
            const SizedBox(height: 12),
            _buildTeamsAndScore(),
            if (match.home.redCards != null || match.away.redCards != null)
              _buildRedCards(),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchHeader() {
    return Row(
      children: [
        Text(
          'League ${match.leagueId}', // You might want to map leagueId to actual names
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.red.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            match.status.liveTime.short,
            style: TextStyle(
              color: Colors.red.shade700,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamsAndScore() {
    return Row(
      children: [
        Expanded(
          child: Text(
            match.home.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            match.status.scoreStr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            match.away.name,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRedCards() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          padding: const EdgeInsets.only(right: 4),
          child: Container(
            width: 12,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}
