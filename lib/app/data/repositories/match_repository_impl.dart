// lib/data/repositories/match_repository_impl.dart
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:livescore_plus/app/core/errors/exceptions.dart';
import 'package:livescore_plus/app/core/errors/failures.dart';
import 'package:livescore_plus/app/core/values/api_constant.dart';
import 'package:livescore_plus/app/data/models/live_models/live_match_model.dart';
import 'package:livescore_plus/app/data/repositories/match_repository.dart';
import '../datasources/match_local_datasource.dart';
import '../../core/network/network_info.dart';

class LiveMatchRepositoryImpl implements LiveMatchRepository {
  final MatchRemoteDataSource remoteDataSource;
  final MatchLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  LiveMatchRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<LiveMatch>>> getLiveMatches() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMatches = await remoteDataSource.getLiveMatches();
        await localDataSource.cacheMatches(remoteMatches);
        return Right(remoteMatches);
      } on DioException catch (e) {
        return Left(ServerFailure(
          message: e.message ?? 'Server error occurred',
          code: e.response?.statusCode?.toString() ?? 'UNKNOWN',
        ));
      } catch (e) {
        return Left(ServerFailure(
          message: e.toString(),
          code: 'UNKNOWN',
        ));
      }
    } else {
      try {
        final localMatches = await localDataSource.getLastMatches();
        return Right(localMatches);
      } catch (e) {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, LiveMatch>> getMatchDetails(int matchId) async {
    if (await networkInfo.isConnected) {
      try {
        final matchDetails = await remoteDataSource.getMatchDetails(matchId);
        await localDataSource.cacheMatchDetails(matchDetails);
        return Right(matchDetails);
      } on DioException catch (e) {
        return Left(ServerFailure(
          message: e.message ?? 'Server error occurred',
          code: e.response?.statusCode?.toString() ?? 'UNKNOWN',
        ));
      } catch (e) {
        return Left(ServerFailure(
          message: e.toString(),
          code: 'UNKNOWN',
        ));
      }
    } else {
      try {
        final localMatch = await localDataSource.getCachedMatchDetails(matchId);
        return Right(localMatch);
      } catch (e) {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<LiveMatch>>> getFavoriteMatches() async {
    try {
      final favorites = await localDataSource.getFavoriteMatches();
      return Right(favorites);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavoriteMatch(int matchId) async {
    try {
      await localDataSource.toggleFavoriteMatch(matchId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}

// lib/data/datasources/match_remote_datasource.dart
abstract class MatchRemoteDataSource {
  Future<List<LiveMatch>> getLiveMatches();
  Future<LiveMatch> getMatchDetails(int matchId);
}

class MatchRemoteDataSourceImpl implements MatchRemoteDataSource {
  final Dio dio;

  MatchRemoteDataSourceImpl({required this.dio}) {
    dio.options.headers = {
      'x-rapidapi-host': 'free-api-live-football-data.p.rapidapi.com',
      'x-rapidapi-key': ApiConstant.apiKey,
    };
  }

  @override
  Future<List<LiveMatch>> getLiveMatches() async {
    try {
      final response = await dio.get(
        'https://free-api-live-football-data.p.rapidapi.com/football-current-live',
      );

      final matchResponse = MatchResponseModel.fromJson(response.data);
      return matchResponse.response.live;
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<LiveMatch> getMatchDetails(int matchId) async {
    try {
      final response = await dio.get(
        'https://free-api-live-football-data.p.rapidapi.com/football-match-details/$matchId',
      );

      return LiveMatchModel.fromJson(response.data);
    } catch (e) {
      throw ServerException();
    }
  }
}
