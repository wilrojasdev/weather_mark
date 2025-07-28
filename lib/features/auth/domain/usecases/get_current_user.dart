// lib/features/auth/domain/usecases/get_current_user.dart
import 'package:dartz/dartz.dart';
import 'package:weather_mark/core/error/failure.dart';
import 'package:weather_mark/core/usecase/usecase.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUser implements UseCase<User?, NoParams> {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, User?>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}
