// lib/data/datasources/match_local_datasource.dart
import 'dart:convert';

import 'package:livescore_plus/app/core/errors/exceptions.dart';
import 'package:livescore_plus/app/data/models/live_match_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MatchLocalDataSource {
  Future<List<LiveMatch>> getLastMatches();
  Future<LiveMatch> getCachedMatchDetails(int matchId);
  Future<void> cacheMatches(List<LiveMatch> matches);
  Future<void> cacheMatchDetails(LiveMatch match);
  Future<List<LiveMatch>> getFavoriteMatches();
  Future<void> toggleFavoriteMatch(int matchId);
}

class MatchLocalDataSourceImpl implements MatchLocalDataSource {
  final SharedPreferences sharedPreferences;

  MatchLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<LiveMatch>> getLastMatches() async {
    final jsonString = sharedPreferences.getString('CACHED_MATCHES');
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => LiveMatchModel.fromJson(json)).toList();
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheMatches(List<LiveMatch> matches) {
    final jsonList =
        matches.map((match) => (match as LiveMatchModel).toJson()).toList();
    return sharedPreferences.setString('CACHED_MATCHES', json.encode(jsonList));
  }

  @override
  Future<LiveMatch> getCachedMatchDetails(int matchId) async {
    final jsonString = sharedPreferences.getString('CACHED_MATCH_$matchId');
    if (jsonString != null) {
      return LiveMatchModel.fromJson(json.decode(jsonString));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheMatchDetails(LiveMatch match) {
    return sharedPreferences.setString(
      'CACHED_MATCH_${match.id}',
      json.encode((match as LiveMatchModel).toJson()),
    );
  }

  @override
  Future<List<LiveMatch>> getFavoriteMatches() async {
    final favorites = sharedPreferences.getStringList('FAVORITE_MATCHES') ?? [];
    final List<LiveMatch> matches = [];

    for (String matchId in favorites) {
      try {
        final match = await getCachedMatchDetails(int.parse(matchId));
        matches.add(match);
      } catch (e) {
        // Skip failed matches
      }
    }

    return matches;
  }

  @override
  Future<void> toggleFavoriteMatch(int matchId) async {
    final favorites = sharedPreferences.getStringList('FAVORITE_MATCHES') ?? [];
    final stringId = matchId.toString();

    if (favorites.contains(stringId)) {
      favorites.remove(stringId);
    } else {
      favorites.add(stringId);
    }

    await sharedPreferences.setStringList('FAVORITE_MATCHES', favorites);
  }
}
