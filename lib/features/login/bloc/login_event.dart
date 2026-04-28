part of 'login_bloc.dart';

sealed class LoginEvent {}

/// Cuando el usuario escribe en el email
class LoginEmailChanged extends LoginEvent {
  final String email;
  LoginEmailChanged(this.email);
}

/// Cuando el usuario escribe en el password
class LoginPasswordChanged extends LoginEvent {
  final String password;
  LoginPasswordChanged(this.password);
}

/// Cuando presiona el botón Login
class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  LoginSubmitted(this.email, this.password);
}

final class GoogleLoginPressed extends LoginEvent {}

final class FacebookLoginPressed extends LoginEvent {}
