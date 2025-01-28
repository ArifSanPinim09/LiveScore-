class LeagueDetailModel {
  final String status;
  final LeagueDetailResponse response;

  LeagueDetailModel({
    required this.status,
    required this.response,
  });

  factory LeagueDetailModel.fromJson(Map<String, dynamic> json) {
    return LeagueDetailModel(
      status: json['status'] ?? '',
      response: LeagueDetailResponse.fromJson(json['response'] ?? {}),
    );
  }
}

class LeagueDetailResponse {
  final LeagueDetail leagues;

  LeagueDetailResponse({required this.leagues});

  factory LeagueDetailResponse.fromJson(Map<String, dynamic> json) {
    return LeagueDetailResponse(
      leagues: LeagueDetail.fromJson(json['leagues'] ?? {}),
    );
  }
}

class LeagueDetail {
  final int id;
  final String type;
  final String name;
  final String selectedSeason;
  final String latestSeason;
  final String shortName;
  final String country;
  final String? leagueColor;

  LeagueDetail({
    required this.id,
    required this.type,
    required this.name,
    required this.selectedSeason,
    required this.latestSeason,
    required this.shortName,
    required this.country,
    this.leagueColor,
  });

  factory LeagueDetail.fromJson(Map<String, dynamic> json) {
    return LeagueDetail(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      selectedSeason: json['selectedSeason'] ?? '',
      latestSeason: json['latestSeason'] ?? '',
      shortName: json['shortName'] ?? '',
      country: json['country'] ?? '',
      leagueColor: json['leagueColor'],
    );
  }
}
