part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;
  final Map<String, dynamic>? profile;
  final bool requiresVerification;

  const AuthSuccess({
    required this.user,
    this.profile,
    this.requiresVerification = false,
  });

  @override
  List<Object> get props => [user, requiresVerification];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}

class PasswordResetSuccess extends AuthState {
  final String email;

  const PasswordResetSuccess({required this.email});

  @override
  List<Object> get props => [email];
}
