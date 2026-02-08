part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

final class RegisterSubmitted extends RegisterEvent {}

final class RegisterEmailChanged extends RegisterEvent {
  final String email;
  RegisterEmailChanged(this.email);
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;
  RegisterPasswordChanged(this.password);
}
