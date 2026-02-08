part of 'register_bloc.dart';

class RegisterState {
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
  });

  bool get isValid => email.isNotEmpty && password.isNotEmpty;

  RegisterState copyWith({
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
    );
  }
}
