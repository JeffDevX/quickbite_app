part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

final class RegisterSubmitted extends RegisterEvent {}

final class RegisterFirstNameChanged extends RegisterEvent {
  final String firstName;
  RegisterFirstNameChanged(this.firstName);
}

final class RegisterLastNameChanged extends RegisterEvent {
  final String lastName;
  RegisterLastNameChanged(this.lastName);
}

final class RegisterEmailChanged extends RegisterEvent {
  final String email;
  RegisterEmailChanged(this.email);
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;
  RegisterPasswordChanged(this.password);
}
