// league_response.dart

class LeagueResponse {
  final String status;
  final ResponseData response;

  LeagueResponse({
    required this.status,
    required this.response,
  });

  factory LeagueResponse.fromJson(Map<String, dynamic> json) {
    return LeagueResponse(
      status: json['status'],
      response: ResponseData.fromJson(json['response']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'response': response.toJson(),
    };
  }
}

class ResponseData {
  final List<League> leagues;

  ResponseData({
    required this.leagues,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      leagues: (json['leagues'] as List)
          .map((league) => League.fromJson(league))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leagues': leagues.map((league) => league.toJson()).toList(),
    };
  }
}

class League {
  final int id;
  final String name;
  final String localizedName;
  final String logo;

  League({
    required this.id,
    required this.name,
    required this.localizedName,
    required this.logo,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'],
      name: json['name'],
      localizedName: json['localizedName'],
      logo: json['logo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'localizedName': localizedName,
      'logo': logo,
    };
  }
}
