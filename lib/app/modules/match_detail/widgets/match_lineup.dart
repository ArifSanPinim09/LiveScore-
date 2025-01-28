import 'package:flutter/material.dart';
import 'package:livescore_plus/app/data/models/line_up/lineup_model.dart';
import 'dart:math' as math;

class MatchLineupView extends StatelessWidget {
  final TeamLineup homeTeam;
  final TeamLineup awayTeam;

  const MatchLineupView({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2A2A3E),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFormationHeader(context),
            _buildField(context),
            _buildSubstitutes(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFormationHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: _buildTeamFormation(context, homeTeam)),
          Expanded(child: _buildTeamFormation(context, awayTeam)),
        ],
      ),
    );
  }

  Widget _buildTeamFormation(BuildContext context, TeamLineup team) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          team.formation,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          team.name,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildField(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final fieldWidth = screenWidth * 0.95;
        final fieldHeight =
            fieldWidth * 1.5; // Aspect ratio sedikit lebih tinggi

        return Container(
          width: fieldWidth,
          height: fieldHeight,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF1B4D3E),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white24, width: 2),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(
                size: Size(fieldWidth, fieldHeight),
                painter: SoccerFieldPainter(),
              ),
              ..._buildFormationPlayers(
                  fieldWidth, fieldHeight, homeTeam, true),
              ..._buildFormationPlayers(
                  fieldWidth, fieldHeight, awayTeam, false),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildFormationPlayers(
    double fieldWidth,
    double fieldHeight,
    TeamLineup team,
    bool isHome,
  ) {
    final players = team.starters;
    final widgets = <Widget>[];
    final playerSize = fieldWidth * 0.06;

    try {
      final formations = team.formation.split('-').map(int.parse).toList();
      var playerIndex = 0;

      // Kiper
      if (playerIndex < players.length) {
        final keeperY = isHome ? fieldHeight * 0.88 : fieldHeight * 0.12;
        widgets.add(_positionPlayer(
          fieldWidth * 0.5, // Selalu di tengah
          keeperY,
          playerSize,
          players[playerIndex++],
          isHome,
        ));
      }

      // Definisi posisi vertikal standar untuk setiap baris (dari atas ke bawah)
      final verticalPositions = isHome
          ? [
              0.75, // Baris pertama (striker)
              0.62, // Baris kedua
              0.48, // Baris ketiga
              0.35, // Baris keempat (defender)
            ]
          : [
              0.25, // Baris pertama (striker)
              0.38, // Baris kedua
              0.52, // Baris ketiga
              0.65, // Baris keempat (defender)
            ];

      // Proses setiap baris formasi
      for (var row = 0;
          row < formations.length && playerIndex < players.length;
          row++) {
        final currentRow = isHome ? formations.length - 1 - row : row;
        final playersInRow = formations[currentRow];
        if (playersInRow <= 0) continue;

        // Gunakan posisi vertikal yang sudah didefinisikan
        final yPos = fieldHeight * verticalPositions[row];

        // Definisi posisi horizontal berdasarkan jumlah pemain
        final List<double> horizontalPositions;
        switch (playersInRow) {
          case 1:
            horizontalPositions = [0.5]; // Satu pemain di tengah
            break;
          case 2:
            horizontalPositions = [0.35, 0.65]; // Dua pemain
            break;
          case 3:
            horizontalPositions = [0.25, 0.5, 0.75]; // Tiga pemain
            break;
          case 4:
            horizontalPositions = [0.2, 0.4, 0.6, 0.8]; // Empat pemain
            break;
          case 5:
            horizontalPositions = [
              0.15,
              0.325,
              0.5,
              0.675,
              0.85
            ]; // Lima pemain
            break;
          default:
            // Untuk kasus lain, buat distribusi merata
            horizontalPositions = List.generate(playersInRow, (index) {
              final gap = 0.7 / (playersInRow - 1);
              return 0.15 + (gap * index);
            });
        }

        // Posisikan pemain dalam baris
        for (var pos = 0;
            pos < playersInRow && playerIndex < players.length;
            pos++) {
          widgets.add(_positionPlayer(
            fieldWidth * horizontalPositions[pos],
            yPos,
            playerSize,
            players[playerIndex++],
            isHome,
          ));
        }
      }
    } catch (e) {
      debugPrint('Error building formation: $e');
    }

    return widgets;
  }

  Widget _positionPlayer(
    double x,
    double y,
    double size,
    Player player,
    bool isHome,
  ) {
    return Positioned(
      left: x - (size / 2),
      top: y - (size / 2),
      child: SizedBox(
        width: size,
        child: _buildPlayerWidget(player, isHome, size),
      ),
    );
  }

  Widget _buildPlayerWidget(Player player, bool isHome, double baseSize) {
    final rating = player.performance.rating;

    return SizedBox(
      width: baseSize * 1.3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: baseSize,
            height: baseSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isHome ? const Color(0xFF4A90E2) : Colors.white,
              border: Border.all(color: Colors.white24, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Center(
              child: Text(
                player.shirtNumber ?? '',
                style: TextStyle(
                  color: isHome ? Colors.white : const Color(0xFF2A2A3E),
                  fontWeight: FontWeight.bold,
                  fontSize: baseSize * 0.45,
                ),
              ),
            ),
          ),
          if (rating != null) ...[
            const SizedBox(height: 2),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: baseSize * 0.2,
                vertical: baseSize * 0.05,
              ),
              decoration: BoxDecoration(
                color: _getRatingColor(rating),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                rating.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: baseSize * 0.3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          const SizedBox(height: 2),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            padding: EdgeInsets.symmetric(
              horizontal: baseSize * 0.15,
              vertical: baseSize * 0.05,
            ),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              player.lastName,
              style: TextStyle(
                color: Colors.white,
                fontSize: baseSize * 0.25,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubstitutes(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Substitutes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: homeTeam.subs.length,
                  itemBuilder: (context, index) =>
                      _buildSubItem(context, homeTeam.subs[index]),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: awayTeam.subs.length,
                  itemBuilder: (context, index) =>
                      _buildSubItem(context, awayTeam.subs[index]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubItem(BuildContext context, Player player) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: Center(
              child: Text(
                player.shirtNumber ?? '',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              player.name,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 7.5) return Colors.green;
    if (rating >= 6.5) return Colors.blue;
    if (rating >= 5.5) return Colors.orange;
    return Colors.red;
  }
}

class SoccerFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    _drawField(canvas, size, paint);
  }

  void _drawField(Canvas canvas, Size size, Paint paint) {
    // Garis tengah
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );

    // Lingkaran tengah
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 5,
      paint,
    );

    // Titik tengah
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      2,
      paint..style = PaintingStyle.fill,
    );

    // Area penalti
    final penaltyAreaHeight = size.height / 4;
    final penaltyAreaWidth = size.width * 0.7;

    // Area gawang
    final goalAreaHeight = size.height / 8;
    final goalAreaWidth = size.width * 0.4;

    // Gambar area penalti dan gawang
    _drawAreas(canvas, size, paint, penaltyAreaWidth, penaltyAreaHeight,
        goalAreaWidth, goalAreaHeight);
  }

  void _drawAreas(Canvas canvas, Size size, Paint paint, double penaltyWidth,
      double penaltyHeight, double goalWidth, double goalHeight) {
    // Area penalti atas
    _drawArea(canvas, size, paint, penaltyWidth, penaltyHeight, true);
    // Area penalti bawah
    _drawArea(canvas, size, paint, penaltyWidth, penaltyHeight, false);

    // Area gawang atas
    _drawArea(canvas, size, paint, goalWidth, goalHeight, true);
    // Area gawang bawah
    _drawArea(canvas, size, paint, goalWidth, goalHeight, false);
  }

  void _drawArea(Canvas canvas, Size size, Paint paint, double width,
      double height, bool isTop) {
    final y = isTop ? 0.0 : size.height - height;
    canvas.drawRect(
      Rect.fromLTWH(
        (size.width - width) / 2,
        y,
        width,
        height,
      ),
      paint..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
