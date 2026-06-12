import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olshopapp/core/storage/local_storage.dart';
import 'package:olshopapp/core/usecase/usecase.dart';
import 'package:olshopapp/features/auth/domain/usecases/login.dart';
import 'package:olshopapp/features/auth/domain/usecases/register.dart';
import 'package:olshopapp/features/auth/domain/usecases/social_login.dart';
import 'package:olshopapp/features/auth/domain/usecases/logout.dart';
import 'package:olshopapp/features/auth/presentation/bloc/auth_event.dart';
import 'package:olshopapp/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final SocialLoginUseCase socialLoginUseCase;
  final LogoutUseCase logoutUseCase;
  final LocalStorage localStorage;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.socialLoginUseCase,
    required this.logoutUseCase,
    required this.localStorage,
  }) : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      emit(AuthChecking());
      // Small delay to show splash screen
      await Future.delayed(const Duration(seconds: 2));
      final user = localStorage.getUser();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await loginUseCase(LoginParams(email: event.email, password: event.password));
      await result.fold(
        (failure) async => emit(AuthError(failure.message)),
        (user) async {
          await localStorage.saveUser(user);
          emit(Authenticated(user));
        },
      );
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await registerUseCase(RegisterParams(name: event.name, email: event.email, password: event.password));
      await result.fold(
        (failure) async => emit(AuthError(failure.message)),
        (user) async {
          await localStorage.saveUser(user);
          emit(Authenticated(user));
        },
      );
    });

    on<SocialLoginRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await socialLoginUseCase(event.provider);
      await result.fold(
        (failure) async => emit(AuthError(failure.message)),
        (user) async {
          await localStorage.saveUser(user);
          emit(Authenticated(user));
        },
      );
    });

    on<LogoutRequested>((event, emit) async {
      final result = await logoutUseCase(NoParams());
      await result.fold(
        (failure) async => emit(AuthError(failure.message)),
        (_) async {
          await localStorage.logout();
          emit(Unauthenticated());
        },
      );
    });
  }
}
