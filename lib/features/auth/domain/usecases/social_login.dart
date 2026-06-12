import 'package:dartz/dartz.dart';
import 'package:olshopapp/core/error/failures.dart';
import 'package:olshopapp/core/usecase/usecase.dart';
import 'package:olshopapp/features/auth/domain/entities/user.dart';
import 'package:olshopapp/features/auth/domain/repositories/auth_repository.dart';

enum SocialProvider { google }

class SocialLoginUseCase implements UseCase<User, SocialProvider> {
  final AuthRepository repository;

  SocialLoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(SocialProvider provider) async {
    switch (provider) {
      case SocialProvider.google:
        return await repository.signInWithGoogle();
    }
  }
}
