// lib/core/error/failures.dart
abstract class Failure {
  final String message;
  final String code;

  Failure({required this.message, required this.code});
}

class ServerFailure extends Failure {
  ServerFailure({required super.message, required super.code});
}

class NetworkFailure extends Failure {
  NetworkFailure()
      : super(message: 'No internet connection', code: 'NETWORK_ERROR');
}

class CacheFailure extends Failure {
  CacheFailure() : super(message: 'Cache error occurred', code: 'CACHE_ERROR');
}
