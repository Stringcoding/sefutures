// File: lib/features/auth/bloc/auth_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc({required AuthService authService})
    : _authService = authService,
      super(AuthInitial()) {
    // Event handlers
    on<SignUpRequested>(_onSignUpRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<PasswordResetRequested>(_onPasswordResetRequested);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _authService.signUpWithEmail(
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
        phone: event.phone,
        referralCode: event.referralCode,
      );

      if (response.user != null) {
        emit(
          AuthSuccess(
            user: response.user!,
            requiresVerification: response.session == null,
          ),
        );
      } else {
        emit(const AuthFailure('Email verification required'));
      }
    } on AuthException catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      emit(AuthFailure('Signup failed: ${e.toString()}'));
    }
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _authService.signInWithEmail(
        email: event.email,
        password: event.password,
      );

      final profile = await _authService.getProfile(response.user!.id);

      emit(AuthSuccess(user: response.user!, profile: profile));
    } on AuthException catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      emit(AuthFailure('Login failed: ${e.toString()}'));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authService.signOut();
      emit(const AuthInitial());
    } catch (e) {
      emit(AuthFailure('Logout failed: ${e.toString()}'));
      emit(
        AuthSuccess(user: state.user!, profile: state.profile),
      ); // Revert state
    }
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final session = await _authService.getCurrentSession();
      if (session != null) {
        final profile = await _authService.getProfile(session.user.id);
        emit(AuthSuccess(user: session.user, profile: profile));
      } else {
        emit(const AuthInitial());
      }
    } catch (e) {
      emit(AuthFailure('Session check failed: ${e.toString()}'));
    }
  }

  Future<void> _onPasswordResetRequested(
    PasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authService.resetPassword(event.email);
      emit(PasswordResetSuccess(email: event.email));
    } on AuthException catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      emit(AuthFailure('Password reset failed: ${e.toString()}'));
    } finally {
      if (state is! AuthSuccess) {
        emit(const AuthInitial()); // Return to initial state
      }
    }
  }

  Future<void> _onProfileUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! AuthSuccess) return;

    emit(AuthLoading());
    try {
      await _authService.updateProfile(
        userId: (state as AuthSuccess).user.id,
        firstName: event.firstName,
        lastName: event.lastName,
        phone: event.phone,
      );

      final updatedProfile = await _authService.getProfile(
        (state as AuthSuccess).user.id,
      );
      emit(
        AuthSuccess(user: (state as AuthSuccess).user, profile: updatedProfile),
      );
    } catch (e) {
      emit(AuthFailure('Profile update failed: ${e.toString()}'));
      emit(state); // Revert to previous state
    }
  }
}
