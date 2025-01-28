// # lib/app/modules/home/views/widgets/match_info_card.dart
import 'package:flutter/material.dart';
import 'package:livescore_plus/app/data/models/match_detail/match_detail_model.dart';

class MatchInfoCard extends StatelessWidget {
  final MatchDetail match;

  const MatchInfoCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Tournament', match.parentLeagueName),
            _buildInfoRow('Season', match.parentLeagueSeason),
            _buildInfoRow('Round', match.matchRound),
            _buildInfoRow('Status', _getMatchStatus()),
            _buildInfoRow('Date', match.matchTimeUTC.split(',')[0]),
            _buildInfoRow('Coverage', match.coverageLevel),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _getMatchStatus() {
    if (match.finished) return 'Finished';
    if (match.started) return 'In Progress';
    return 'Not Started';
  }
}
