// lib/core/error/exceptions.dart
class ServerException implements Exception {
  final String? message;
  final String? code;

  ServerException({this.message, this.code});
}

class CacheException implements Exception {
  final String? message;

  CacheException({this.message});
}
