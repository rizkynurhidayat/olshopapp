import 'package:dartz/dartz.dart';
import 'package:olshopapp/core/error/failures.dart';
import 'package:olshopapp/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register(String name, String email, String password);
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, void>> logout();
}
