// lib/features/auth/domain/usecases/login.dart
import 'package:dartz/dartz.dart';
import 'package:weather_mark/core/usecase/usecase.dart';
import '../../../../core/error/failure.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Login implements UseCase<User, NoParams> {
  final AuthRepository repository;

  Login(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.login();
  }
}
