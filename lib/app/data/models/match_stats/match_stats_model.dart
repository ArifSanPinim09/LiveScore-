// lib/app/data/models/match_stats/match_stats_model.dart

class MatchStatsResponse {
  final String status;
  final StatsResponse response;

  MatchStatsResponse({
    required this.status,
    required this.response,
  });

  factory MatchStatsResponse.fromJson(Map<String, dynamic> json) {
    return MatchStatsResponse(
      status: json['status'],
      response: StatsResponse.fromJson(json['response']),
    );
  }
}

class StatsResponse {
  final List<StatCategory> stats;

  StatsResponse({required this.stats});

  factory StatsResponse.fromJson(Map<String, dynamic> json) {
    return StatsResponse(
      stats: (json['stats'] as List)
          .map((stat) => StatCategory.fromJson(stat))
          .toList(),
    );
  }
}

class StatCategory {
  final String title;
  final String key;
  final List<StatItem> stats;

  StatCategory({
    required this.title,
    required this.key,
    required this.stats,
  });

  factory StatCategory.fromJson(Map<String, dynamic> json) {
    return StatCategory(
      title: json['title'],
      key: json['key'],
      stats: (json['stats'] as List)
          .map((stat) => StatItem.fromJson(stat))
          .toList(),
    );
  }
}

class StatItem {
  final String title;
  final String key;
  final List<dynamic> stats;
  final String type;
  final String highlighted;

  StatItem({
    required this.title,
    required this.key,
    required this.stats,
    required this.type,
    required this.highlighted,
  });

  factory StatItem.fromJson(Map<String, dynamic> json) {
    return StatItem(
      title: json['title'],
      key: json['key'],
      stats: json['stats'] as List<dynamic>,
      type: json['type'],
      highlighted: json['highlighted'],
    );
  }
}
