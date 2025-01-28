// lib/app/data/models/lineup/lineup_model.dart

class LineupResponse {
  final String status;
  final LineupData response;

  LineupResponse({
    required this.status,
    required this.response,
  });

  factory LineupResponse.fromJson(Map<String, dynamic> json) {
    return LineupResponse(
      status: json['status'],
      response: LineupData.fromJson(json['response']),
    );
  }
}

class LineupData {
  final TeamLineup lineup;

  LineupData({required this.lineup});

  factory LineupData.fromJson(Map<String, dynamic> json) {
    return LineupData(
      lineup: TeamLineup.fromJson(json['lineup']),
    );
  }
}

class TeamLineup {
  final int id;
  final String name;
  final double rating;
  final String formation;
  final List<Player> starters;
  final Coach coach;
  final List<Player> subs;
  final List<Player> unavailable;
  final double averageStarterAge;

  TeamLineup({
    required this.id,
    required this.name,
    required this.rating,
    required this.formation,
    required this.starters,
    required this.coach,
    required this.subs,
    required this.unavailable,
    required this.averageStarterAge,
  });

  factory TeamLineup.fromJson(Map<String, dynamic> json) {
    return TeamLineup(
      id: json['id'],
      name: json['name'],
      rating: json['rating'].toDouble(),
      formation: json['formation'],
      starters: (json['starters'] as List)
          .map((player) => Player.fromJson(player))
          .toList(),
      coach: Coach.fromJson(json['coach']),
      subs: (json['subs'] as List)
          .map((player) => Player.fromJson(player))
          .toList(),
      unavailable: (json['unavailable'] as List)
          .map((player) => Player.fromJson(player))
          .toList(),
      averageStarterAge: json['averageStarterAge'].toDouble(),
    );
  }
}

class Player {
  final int id;
  final int age;
  final String name;
  final String? shirtNumber;
  final String countryName;
  final String countryCode;
  final Layout? horizontalLayout;
  final Layout? verticalLayout;
  final Performance performance;
  final String firstName;
  final String lastName;

  Player({
    required this.id,
    required this.age,
    required this.name,
    this.shirtNumber,
    required this.countryName,
    required this.countryCode,
    this.horizontalLayout,
    this.verticalLayout,
    required this.performance,
    required this.firstName,
    required this.lastName,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      age: json['age'],
      name: json['name'],
      shirtNumber: json['shirtNumber']?.toString(),
      countryName: json['countryName'],
      countryCode: json['countryCode'],
      horizontalLayout: json['horizontalLayout'] != null
          ? Layout.fromJson(json['horizontalLayout'])
          : null,
      verticalLayout: json['verticalLayout'] != null
          ? Layout.fromJson(json['verticalLayout'])
          : null,
      performance: Performance.fromJson(json['performance'] ?? {}),
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}

class Layout {
  final double x;
  final double y;
  final double height;
  final double width;

  Layout({
    required this.x,
    required this.y,
    required this.height,
    required this.width,
  });

  factory Layout.fromJson(Map<String, dynamic> json) {
    return Layout(
      x: json['x'].toDouble(),
      y: json['y'].toDouble(),
      height: json['height'].toDouble(),
      width: json['width'].toDouble(),
    );
  }
}

class Performance {
  final double? rating;
  final List<Event>? events;
  final List<SubstitutionEvent>? substitutionEvents;

  Performance({
    this.rating,
    this.events,
    this.substitutionEvents,
  });

  factory Performance.fromJson(Map<String, dynamic> json) {
    return Performance(
      rating: json['rating']?.toDouble(),
      events: json['events'] != null
          ? (json['events'] as List).map((e) => Event.fromJson(e)).toList()
          : null,
      substitutionEvents: json['substitutionEvents'] != null
          ? (json['substitutionEvents'] as List)
              .map((e) => SubstitutionEvent.fromJson(e))
              .toList()
          : null,
    );
  }
}

class Event {
  final String type;

  Event({required this.type});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      type: json['type'],
    );
  }
}

class SubstitutionEvent {
  final int time;
  final String type;
  final String reason;

  SubstitutionEvent({
    required this.time,
    required this.type,
    required this.reason,
  });

  factory SubstitutionEvent.fromJson(Map<String, dynamic> json) {
    return SubstitutionEvent(
      time: json['time'],
      type: json['type'],
      reason: json['reason'],
    );
  }
}

class Coach {
  final int id;
  final int age;
  final String name;
  final String countryName;
  final String countryCode;
  final String firstName;
  final String lastName;

  Coach({
    required this.id,
    required this.age,
    required this.name,
    required this.countryName,
    required this.countryCode,
    required this.firstName,
    required this.lastName,
  });

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      id: json['id'],
      age: json['age'],
      name: json['name'],
      countryName: json['countryName'],
      countryCode: json['countryCode'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}
