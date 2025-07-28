class ServerException implements Exception {
  String? message;

  ServerException(this.message);
}

class CacheException implements Exception {}

class NetworkException implements Exception {}

class AuthenticationException implements Exception {}

class Auth0Exception implements Exception {}
