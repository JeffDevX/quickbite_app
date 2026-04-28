part of 'register_bloc.dart';

class RegisterState {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final bool isLoading;
  final bool isSuccess;
  final String errorMessage;

  const RegisterState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage = '',
    this.firstName = '',
    this.lastName = '',
  });

  bool get isValid => email.isNotEmpty && password.isNotEmpty;

  RegisterState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }
}
