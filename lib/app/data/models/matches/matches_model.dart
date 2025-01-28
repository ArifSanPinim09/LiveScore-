class Matches {
  final String id;
  final String leagueId;
  final String time;
  final Team home;
  final Team away;
  final MatchesStatus status;
  String? shortName;
  String? homeImageUrl;
  String? awayImageUrl;
  String? leagueLogo;

  Matches({
    required this.id,
    required this.leagueId,
    required this.time,
    required this.home,
    required this.away,
    required this.status,
    this.shortName,
    this.homeImageUrl,
    this.awayImageUrl,
    this.leagueLogo,
  });

  factory Matches.fromJson(Map<String, dynamic> json) {
    return Matches(
      id: json['id'].toString(),
      leagueId: json['leagueId'].toString(),
      time: json['time'],
      home: Team.fromJson(json['home']),
      away: Team.fromJson(json['away']),
      status: MatchesStatus.fromJson(json['status']),
      shortName: json['shortName'],
      homeImageUrl: json['homeImageUrl'],
      awayImageUrl: json['awayImageUrl'],
      leagueLogo: json['leagueLogo'],
    );
  }
}

class Team {
  final String id;
  final String name;
  final String longName;
  final int score;
  final int? redCards;

  Team({
    required this.id,
    required this.name,
    required this.longName,
    required this.score,
    this.redCards,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'].toString(),
      name: json['name'],
      longName: json['longName'] ?? json['name'],
      score: json['score'] ?? 0,
      redCards: json['redCards'],
    );
  }
}

class MatchesStatus {
  final String utcTime;
  final bool finished;
  final bool started;
  final String scoreStr;
  final StatusReason reason;

  MatchesStatus({
    required this.utcTime,
    required this.finished,
    required this.started,
    required this.scoreStr,
    required this.reason,
  });

  factory MatchesStatus.fromJson(Map<String, dynamic> json) {
    return MatchesStatus(
      utcTime: json['utcTime'],
      finished: json['finished'] ?? false,
      started: json['started'] ?? false,
      scoreStr: json['scoreStr'] ?? '0 - 0',
      reason: StatusReason.fromJson(json['reason'] ?? {}),
    );
  }
}

class StatusReason {
  final String short;
  final String long;

  StatusReason({
    required this.short,
    required this.long,
  });

  factory StatusReason.fromJson(Map<String, dynamic> json) {
    return StatusReason(
      short: json['short'] ?? '',
      long: json['long'] ?? '',
    );
  }
}
