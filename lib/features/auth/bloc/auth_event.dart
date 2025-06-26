part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? referralCode;

  const SignUpRequested({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.referralCode,
  });

  @override
  List<Object> get props => [email, password, firstName, lastName];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignOutRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class PasswordResetRequested extends AuthEvent {
  final String email;

  const PasswordResetRequested(this.email);

  @override
  List<Object> get props => [email];
}

class ProfileUpdateRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String? phone;

  const ProfileUpdateRequested({
    required this.firstName,
    required this.lastName,
    this.phone,
  });

  @override
  List<Object> get props => [firstName, lastName];
}
