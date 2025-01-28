// # lib/app/data/models/match_detail_model.dart

class MatchDetailResponse {
  final String status;
  final MatchScores response;

  MatchDetailResponse({
    required this.status,
    required this.response,
  });

  factory MatchDetailResponse.fromJson(Map<String, dynamic> json) =>
      MatchDetailResponse(
        status: json["status"],
        response: MatchScores.fromJson(json["response"]),
      );
}

class MatchScores {
  final List<TeamScore> scores;

  MatchScores({required this.scores});

  factory MatchScores.fromJson(Map<String, dynamic> json) => MatchScores(
        scores: List<TeamScore>.from(
            json["scores"].map((x) => TeamScore.fromJson(x))),
      );
}

class TeamScore {
  final String name;
  final int id;
  final int score;
  final String imageUrl;
  final dynamic fifaRank;

  TeamScore({
    required this.name,
    required this.id,
    required this.score,
    required this.imageUrl,
    this.fifaRank,
  });

  factory TeamScore.fromJson(Map<String, dynamic> json) => TeamScore(
        name: json["name"],
        id: json["id"],
        score: json["score"],
        imageUrl: json["imageUrl"],
        fifaRank: json["fifaRank"],
      );
}

class MatchDetailData {
  final MatchDetail detail;

  MatchDetailData({required this.detail});

  factory MatchDetailData.fromJson(Map<String, dynamic> json) =>
      MatchDetailData(
        detail: MatchDetail.fromJson(json["detail"]),
      );
}

class MatchDetail {
  final String matchId;
  final String matchName;
  final String matchRound;
  final TeamColors teamColors;
  final String leagueId;
  final String leagueName;
  final String leagueRoundName;
  final String parentLeagueId;
  final String countryCode;
  final String parentLeagueName;
  final String parentLeagueSeason;
  final String parentLeagueTournamentId;
  final Team homeTeam;
  final Team awayTeam;
  final String coverageLevel;
  final String matchTimeUTC;
  final String matchTimeUTCDate;
  final bool started;
  final bool finished;

  MatchDetail({
    required this.matchId,
    required this.matchName,
    required this.matchRound,
    required this.teamColors,
    required this.leagueId,
    required this.leagueName,
    required this.leagueRoundName,
    required this.parentLeagueId,
    required this.countryCode,
    required this.parentLeagueName,
    required this.parentLeagueSeason,
    required this.parentLeagueTournamentId,
    required this.homeTeam,
    required this.awayTeam,
    required this.coverageLevel,
    required this.matchTimeUTC,
    required this.matchTimeUTCDate,
    required this.started,
    required this.finished,
  });

  factory MatchDetail.fromJson(Map<String, dynamic> json) => MatchDetail(
        matchId: json["matchId"],
        matchName: json["matchName"],
        matchRound: json["matchRound"],
        teamColors: TeamColors.fromJson(json["teamColors"]),
        leagueId: json["leagueId"].toString(),
        leagueName: json["leagueName"],
        leagueRoundName: json["leagueRoundName"],
        parentLeagueId: json["parentLeagueId"].toString(),
        countryCode: json["countryCode"],
        parentLeagueName: json["parentLeagueName"],
        parentLeagueSeason: json["parentLeagueSeason"],
        parentLeagueTournamentId: json["parentLeagueTournamentId"].toString(),
        homeTeam: Team.fromJson(json["homeTeam"]),
        awayTeam: Team.fromJson(json["awayTeam"]),
        coverageLevel: json["coverageLevel"],
        matchTimeUTC: json["matchTimeUTC"],
        matchTimeUTCDate: json["matchTimeUTCDate"],
        started: json["started"],
        finished: json["finished"],
      );
}

class Team {
  final String name;
  final String id;

  Team({
    required this.name,
    required this.id,
  });

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        name: json["name"],
        id: json["id"].toString(),
      );
}

class TeamColors {
  final ColorMode darkMode;
  final ColorMode lightMode;
  final FontMode fontDarkMode;
  final FontMode fontLightMode;

  TeamColors({
    required this.darkMode,
    required this.lightMode,
    required this.fontDarkMode,
    required this.fontLightMode,
  });

  factory TeamColors.fromJson(Map<String, dynamic> json) => TeamColors(
        darkMode: ColorMode.fromJson(json["darkMode"]),
        lightMode: ColorMode.fromJson(json["lightMode"]),
        fontDarkMode: FontMode.fromJson(json["fontDarkMode"]),
        fontLightMode: FontMode.fromJson(json["fontLightMode"]),
      );
}

class ColorMode {
  final String home;
  final String away;

  ColorMode({
    required this.home,
    required this.away,
  });

  factory ColorMode.fromJson(Map<String, dynamic> json) => ColorMode(
        home: json["home"],
        away: json["away"],
      );
}

class FontMode {
  final String home;
  final String away;

  FontMode({
    required this.home,
    required this.away,
  });

  factory FontMode.fromJson(Map<String, dynamic> json) => FontMode(
        home: json["home"],
        away: json["away"],
      );
}
