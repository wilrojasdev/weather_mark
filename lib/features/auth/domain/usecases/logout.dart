// lib/features/auth/domain/usecases/logout.dart
import 'package:dartz/dartz.dart';
import 'package:weather_mark/core/error/failure.dart';
import 'package:weather_mark/core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class Logout implements UseCase<void, NoParams> {
  final AuthRepository repository;

  Logout(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}
