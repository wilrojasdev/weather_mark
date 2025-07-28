// lib/features/auth/presentation/bloc/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_mark/core/error/failure.dart';
import 'package:weather_mark/core/usecase/usecase.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final Logout logout;
  final GetCurrentUser getCurrentUser;

  AuthBloc({
    required this.login,
    required this.logout,
    required this.getCurrentUser,
  }) : super(Unauthenticated()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await getCurrentUser(NoParams());

    result.fold(
      (failure) => emit(Unauthenticated()),
      (user) => user != null
          ? emit(Authenticated(user: user))
          : emit(Unauthenticated()),
    );
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(isLogout: false));

    try {
      final result = await login(NoParams());

      await result.fold(
        (failure) async {
          if (failure is AuthFailure) {
            if (failure.isUserCancelled) {
              emit(Unauthenticated());
            } else {
              emit(const AuthError(
                  message:
                      'Error al iniciar sesión. Por favor, intenta de nuevo.'));

              await Future.delayed(const Duration(seconds: 3));
              emit(Unauthenticated());
            }
          } else {
            emit(const AuthError(message: 'Error al iniciar sesión'));
            await Future.delayed(const Duration(seconds: 3));
            emit(Unauthenticated());
          }
        },
        (user) async => emit(Authenticated(user: user)),
      );
    } catch (e) {
      emit(const AuthError(message: 'Ocurrió un error inesperado'));
      await Future.delayed(const Duration(seconds: 3));
      emit(Unauthenticated());
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(isLogout: true));
    final result = await logout(NoParams());

    result.fold(
      (failure) {
        emit(const AuthError(message: 'Error al cerrar sesión'));

        emit(Unauthenticated());
      },
      (_) => emit(Unauthenticated()),
    );
  }
}
