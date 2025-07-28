import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);
}

class ServerFailure extends Failure {
  final String? message;

  const ServerFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class NoDataFailure extends Failure {
  @override
  List<Object?> get props => [""];
}

class CacheFailure extends Failure {
  @override
  List<Object?> get props => [""];
}

class NetworkFailure extends Failure {
  @override
  List<Object?> get props => [""];
}

class AuthenticationFailure extends Failure {
  @override
  List<Object?> get props => [""];
}

class UserCancelledFailure extends Failure {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'user_cancelled';
}

class AuthFailure extends Failure {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object> get props => [message];

  bool get isUserCancelled => message == 'user_cancelled';
}
