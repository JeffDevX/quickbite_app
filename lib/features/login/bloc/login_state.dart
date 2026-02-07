part of 'login_bloc.dart';

@immutable
sealed class LoginState {
  final String password;
  final String email;

  const LoginState({required this.password, required this.email});
}

final class LoginInitial extends LoginState {
  const LoginInitial() : super(password: '', email: '');
}

final class LoginLoading extends LoginState {
  const LoginLoading({required super.password, required super.email});
}

final class LoginSuccess extends LoginState {
  const LoginSuccess({required super.password, required super.email});
}

final class LoginError extends LoginState {
  final String message;

  const LoginError({
    required this.message,
    required super.password,
    required super.email,
  });
}
