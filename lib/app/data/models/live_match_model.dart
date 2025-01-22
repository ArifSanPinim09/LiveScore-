// lib/domain/entities/live_match.dart
abstract class LiveMatch {
  final int id;
  final int leagueId;
  final String time;
  final Team home;
  final Team away;
  final MatchStatus status;

  LiveMatch({
    required this.id,
    required this.leagueId,
    required this.time,
    required this.home,
    required this.away,
    required this.status,
  });
}

abstract class Team {
  final int id;
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
}

abstract class MatchStatus {
  final String utcTime;
  final Halfs halfs;
  final bool finished;
  final bool started;
  final bool cancelled;
  final bool ongoing;
  final String scoreStr;
  final LiveTime liveTime;

  MatchStatus({
    required this.utcTime,
    required this.halfs,
    required this.finished,
    required this.started,
    required this.cancelled,
    required this.ongoing,
    required this.scoreStr,
    required this.liveTime,
  });
}

abstract class Halfs {
  final String firstHalfStarted;
  final String? secondHalfStarted;

  Halfs({
    required this.firstHalfStarted,
    this.secondHalfStarted,
  });
}

abstract class LiveTime {
  final String short;
  final String shortKey;
  final String long;
  final String longKey;
  final int maxTime;
  final int addedTime;

  LiveTime({
    required this.short,
    required this.shortKey,
    required this.long,
    required this.longKey,
    required this.maxTime,
    required this.addedTime,
  });
}

// lib/data/models/live_match_model.dart

class MatchResponseModel {
  final String status;
  final LiveMatchesResponse response;

  MatchResponseModel({
    required this.status,
    required this.response,
  });

  factory MatchResponseModel.fromJson(Map<String, dynamic> json) {
    return MatchResponseModel(
      status: json['status'],
      response: LiveMatchesResponse.fromJson(json['response']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'response': response.toJson(),
    };
  }
}

class LiveMatchesResponse {
  final List<LiveMatchModel> live;

  LiveMatchesResponse({required this.live});

  factory LiveMatchesResponse.fromJson(Map<String, dynamic> json) {
    return LiveMatchesResponse(
      live: (json['live'] as List)
          .map((match) => LiveMatchModel.fromJson(match))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'live': live.map((match) => match.toJson()).toList(),
    };
  }
}

class LiveMatchModel extends LiveMatch {
  LiveMatchModel({
    required super.id,
    required super.leagueId,
    required super.time,
    required TeamModel home,
    required TeamModel away,
    required MatchStatusModel status,
  }) : super(
          home: home,
          away: away,
          status: status,
        );

  factory LiveMatchModel.fromJson(Map<String, dynamic> json) {
    return LiveMatchModel(
      id: json['id'],
      leagueId: json['leagueId'],
      time: json['time'],
      home: TeamModel.fromJson(json['home']),
      away: TeamModel.fromJson(json['away']),
      status: MatchStatusModel.fromJson(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'leagueId': leagueId,
      'time': time,
      'home': (home as TeamModel).toJson(),
      'away': (away as TeamModel).toJson(),
      'status': (status as MatchStatusModel).toJson(),
    };
  }
}

class TeamModel extends Team {
  TeamModel({
    required super.id,
    required super.name,
    required super.longName,
    required super.score,
    super.redCards,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'],
      name: json['name'],
      longName: json['longName'],
      score: json['score'],
      redCards: json['redCards'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'longName': longName,
      'score': score,
      if (redCards != null) 'redCards': redCards,
    };
  }
}

class MatchStatusModel extends MatchStatus {
  MatchStatusModel({
    required super.utcTime,
    required HalfsModel halfs,
    required super.finished,
    required super.started,
    required super.cancelled,
    required super.ongoing,
    required super.scoreStr,
    required LiveTimeModel liveTime,
  }) : super(halfs: halfs, liveTime: liveTime);

  factory MatchStatusModel.fromJson(Map<String, dynamic> json) {
    return MatchStatusModel(
      utcTime: json['utcTime'],
      halfs: HalfsModel.fromJson(json['halfs']),
      finished: json['finished'],
      started: json['started'],
      cancelled: json['cancelled'],
      ongoing: json['ongoing'],
      scoreStr: json['scoreStr'],
      liveTime: LiveTimeModel.fromJson(json['liveTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'utcTime': utcTime,
      'halfs': (halfs as HalfsModel).toJson(),
      'finished': finished,
      'started': started,
      'cancelled': cancelled,
      'ongoing': ongoing,
      'scoreStr': scoreStr,
      'liveTime': (liveTime as LiveTimeModel).toJson(),
    };
  }
}

class HalfsModel extends Halfs {
  HalfsModel({
    required super.firstHalfStarted,
    super.secondHalfStarted,
  });

  factory HalfsModel.fromJson(Map<String, dynamic> json) {
    return HalfsModel(
      firstHalfStarted: json['firstHalfStarted'],
      secondHalfStarted: json['secondHalfStarted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstHalfStarted': firstHalfStarted,
      if (secondHalfStarted != null) 'secondHalfStarted': secondHalfStarted,
    };
  }
}

class LiveTimeModel extends LiveTime {
  LiveTimeModel({
    required super.short,
    required super.shortKey,
    required super.long,
    required super.longKey,
    required super.maxTime,
    required super.addedTime,
  });

  factory LiveTimeModel.fromJson(Map<String, dynamic> json) {
    return LiveTimeModel(
      short: json['short'],
      shortKey: json['shortKey'],
      long: json['long'],
      longKey: json['longKey'],
      maxTime: json['maxTime'],
      addedTime: json['addedTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'short': short,
      'shortKey': shortKey,
      'long': long,
      'longKey': longKey,
      'maxTime': maxTime,
      'addedTime': addedTime,
    };
  }
}
