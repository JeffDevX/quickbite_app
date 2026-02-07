part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

final class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  LoginSubmitted({required this.email, required this.password});
}

final class GoogleLoginPressed extends LoginEvent {}

final class FacebookLoginPressed extends LoginEvent {}
