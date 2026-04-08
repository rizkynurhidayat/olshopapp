import 'package:dartz/dartz.dart';
import 'package:olshopapp/core/error/failures.dart';
import 'package:olshopapp/core/usecase/usecase.dart';
import 'package:olshopapp/features/auth/domain/entities/user.dart';
import 'package:olshopapp/features/auth/domain/repositories/auth_repository.dart';

class RegisterParams {
  final String name;
  final String email;
  final String password;
  RegisterParams({required this.name, required this.email, required this.password});
}

class RegisterUseCase implements UseCase<User, RegisterParams> {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.register(params.name, params.email, params.password);
  }
}
