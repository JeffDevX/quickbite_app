part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {
  final String email;
  final String password;

  const RegisterEvent({required this.email, required this.password});
}
