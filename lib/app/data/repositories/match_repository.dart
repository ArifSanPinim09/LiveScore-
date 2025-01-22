import 'package:dartz/dartz.dart';
import 'package:livescore_plus/app/core/errors/failures.dart';
import 'package:livescore_plus/app/data/models/live_match_model.dart';

abstract class MatchRepository {
  Future<Either<Failure, List<LiveMatch>>> getLiveMatches();
  Future<Either<Failure, LiveMatch>> getMatchDetails(int matchId);
  Future<Either<Failure, List<LiveMatch>>> getFavoriteMatches();
  Future<Either<Failure, void>> toggleFavoriteMatch(int matchId);
}
