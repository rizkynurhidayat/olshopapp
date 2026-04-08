import 'package:dartz/dartz.dart';
import 'package:olshopapp/core/error/failures.dart';
import 'package:olshopapp/features/auth/domain/entities/user.dart';
import 'package:olshopapp/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'user@example.com' && password == 'password') {
      return const Right(User(id: '1', email: 'user@example.com', name: 'John Doe'));
    }
    return const Left(ServerFailure('Invalid email or password'));
  }

  @override
  Future<Either<Failure, User>> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return Right(User(id: '2', email: email, name: name));
  }
}
