// standing_by_league.dart

class StandingResponse {
  final String? status;
  final StandingData? response;

  StandingResponse({
    this.status,
    this.response,
  });

  factory StandingResponse.fromJson(Map<String, dynamic> json) {
    return StandingResponse(
      status: json['status'] as String?,
      response: json['response'] != null
          ? StandingData.fromJson(json['response'] as Map<String, dynamic>)
          : null,
    );
  }
}

class StandingData {
  final List<TeamStanding> standing;

  StandingData({
    required this.standing,
  });

  factory StandingData.fromJson(Map<String, dynamic> json) {
    var standingList = json['standing'] as List?;
    return StandingData(
      standing:
          standingList?.map((x) => TeamStanding.fromJson(x)).toList() ?? [],
    );
  }
}

class TeamStanding {
  final String? name;
  final String? shortName;
  final int? id;
  final String? pageUrl;
  final int? deduction;
  final String? ongoing;
  final int? played;
  final int? wins;
  final int? draws;
  final int? losses;
  final String? scoresStr;
  final int? goalConDiff;
  final int? pts;
  final int? idx;
  final String? qualColor;

  TeamStanding({
    this.name,
    this.shortName,
    this.id,
    this.pageUrl,
    this.deduction,
    this.ongoing,
    this.played,
    this.wins,
    this.draws,
    this.losses,
    this.scoresStr,
    this.goalConDiff,
    this.pts,
    this.idx,
    this.qualColor,
  });

  factory TeamStanding.fromJson(Map<String, dynamic> json) {
    return TeamStanding(
      name: json['name'] as String?,
      shortName: json['shortName'] as String?,
      id: json['id'] as int?,
      pageUrl: json['pageUrl'] as String?,
      deduction: json['deduction'] as int?,
      ongoing: json['ongoing'] as String?,
      played: json['played'] as int?,
      wins: json['wins'] as int?,
      draws: json['draws'] as int?,
      losses: json['losses'] as int?,
      scoresStr: json['scoresStr'] as String?,
      goalConDiff: json['goalConDiff'] as int?,
      pts: json['pts'] as int?,
      idx: json['idx'] as int?,
      qualColor: json['qualColor'] as String?,
    );
  }
}
