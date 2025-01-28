class LeagueLogoModel {
  final String status;
  final LeagueLogoResponse response;

  LeagueLogoModel({
    required this.status,
    required this.response,
  });

  factory LeagueLogoModel.fromJson(Map<String, dynamic> json) {
    return LeagueLogoModel(
      status: json['status'] ?? '',
      response: LeagueLogoResponse.fromJson(json['response'] ?? {}),
    );
  }
}

class LeagueLogoResponse {
  final String url;

  LeagueLogoResponse({required this.url});

  factory LeagueLogoResponse.fromJson(Map<String, dynamic> json) {
    return LeagueLogoResponse(
      url: json['url'] ?? '',
    );
  }
}
